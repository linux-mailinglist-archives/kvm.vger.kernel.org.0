Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5B25378EA
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiE3KHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 06:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235067AbiE3KHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 06:07:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05167A827;
        Mon, 30 May 2022 03:07:50 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U7gK1K005553;
        Mon, 30 May 2022 10:07:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=TZ4znyQsI0lnl6cDL8B7n/cmWh+0o3s1W6OHXbUTjkk=;
 b=qxG3IiUPd9Kj2RsFtR7luWgsMpUXLW5TD2VytfzTK2ArToHHptv2TAQKF5P6mMcd5JUS
 YxkQw7Rxro11RHRfXtGesI/UI+/hKuTcEhGHjZKRDgkat6YY5WPZZLWcK5cVMg1/Jg6o
 HKk15D0F9DRLvHG0uFYUZIvvd97XQ7VkyA4vtUZZYaodf/fHCwln6Rfq2/Luww33UW6b
 HTQiXilKEbv1aX0aedajrl834xUO3bIYo2hSVLHmqOzzHplohp7rCcqTili+pTPWSpbj
 yG3K+EKCHWOtRFI/W25Wpng9G9H/egxH2dcDHh96JPAg2ctBxpKhcS6o4H+E1MQW3WN6 uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcsrw2tt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:07:50 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U7k5fW019993;
        Mon, 30 May 2022 10:07:49 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcsrw2tsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:07:49 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U9ppJj014747;
        Mon, 30 May 2022 10:07:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7hvqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 10:07:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UA7hmr31785312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 10:07:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE38FAE053;
        Mon, 30 May 2022 10:07:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4109FAE045;
        Mon, 30 May 2022 10:07:43 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 10:07:43 +0000 (GMT)
Message-ID: <d76e875c360c53d6bd03c3f2767c90dcc4ca6df9.camel@linux.ibm.com>
Subject: Re: [PATCH v10 18/19] KVM: s390: pv: avoid export before import if
 possible
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 30 May 2022 12:07:43 +0200
In-Reply-To: <20220414080311.1084834-19-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-19-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QBZTYuNQdcNsv58ETnhzrF-MCmnGoWsJ
X-Proofpoint-ORIG-GUID: drjplrHCL46X1KlijVoGtLVuk9tfgMH4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:

> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index e358b8bd864b..43393568f844 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -236,7 +236,8 @@ static int make_secure_pte(pte_t *ptep, unsigned
> long addr,
> =C2=A0
> =C2=A0static bool should_export_before_import(struct uv_cb_header *uvcb,
> struct mm_struct *mm)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return uvcb->cmd !=3D UVC_CMD_=
UNPIN_PAGE_SHARED &&
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return !test_bit_inv(BIT_UV_FE=
AT_MISC,
> &uv_info.uv_feature_indications) &&
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0uvcb->cmd !=3D UVC_CMD_UNPIN_PAGE_SHARED &&
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0atomic_read(&mm->context.protected_count) > 1;

This might be nicer to read like this:

if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
  return false;

if (uvcb->cmd =3D=3D UVC_CMD_UNPIN_PAGE_SHARED)
  return false;

return atomic_read(&mm->context.protected_count) > 1;

