Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75C527F27
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 10:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241485AbiEPIFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 04:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbiEPIFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 04:05:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CACC31233;
        Mon, 16 May 2022 01:05:02 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G7NGuB015125;
        Mon, 16 May 2022 08:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4cG4fZ4FABvZZmQJ6VpIHom+4B7L/DL86KLk4eOIYK4=;
 b=KESwY1s3+VdVLFp5m7r5ueiRBHWfYIW9lCKb8DQqsNasuHN6KC1jPJpZuQ57/dcw9+mv
 nmPGIc10MBMsLfax3HWFI+ldKsxm5uN9liBaruv8gAuCW+B0hQXgGCjk1QNiEqJiXtEt
 ZudQn8a2EXfL4XIdmRGMNiFeyNK2viyz+gXeMB25XY0d0gVgUsMlyso9WS3F2mHDLqTM
 KtD4H2TZ1vQ3SttgT2Vkz6G8HulnBR4j+SjJhba081bF4sT8TvS9DxRbp7QBC5XIl2c0
 76fv9f4E5mnck4BSS8Zs0fVuNerVN5OCyz3w4LiU20m8A3KDttQ0zUijKSNsb6D2nkRM Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3ey0c66c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:05:01 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G7a1bS019675;
        Mon, 16 May 2022 08:05:00 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3ey0c65u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:05:00 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G84EdZ016964;
        Mon, 16 May 2022 08:04:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428hrr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:04:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G84t6Y49480168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 08:04:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A3B611C054;
        Mon, 16 May 2022 08:04:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D55ED11C04A;
        Mon, 16 May 2022 08:04:54 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.122])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 08:04:54 +0000 (GMT)
Message-ID: <6948806da404fd5822b59fd65b8a5a948e6bb317.camel@linux.ibm.com>
Subject: Re: [PATCH v10 04/19] KVM: s390: pv: refactor s390_reset_acc
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 16 May 2022 10:04:54 +0200
In-Reply-To: <20220414080311.1084834-5-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lsqWKg8fXlQr6SI_X27VJGgdaVMjHLwB
X-Proofpoint-GUID: z3XyIGc9s1xEsN7Too8IHn4CIxKRVTGW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:02 +0200, Claudio Imbrenda wrote:
> Refactor s390_reset_acc so that it can be reused in upcoming patches.
>=20
> We don't want to hold all the locks used in a walk_page_range for too
> long, and the destroy page UVC does take some time to complete.
> Therefore we quickly gather the pages to destroy, and then destroy
> them
> without holding all the locks.
>=20
> The new refactored function optionally allows to return early without
> completing if a fatal signal is pending (and return and appropriate
> error code). Two wrappers are provided to call the new function.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

But see below with one naming suggestion you might want to take into
account.

[...]
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index e8904cb9dc38..a3a1f90f6ec1 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -2676,44 +2676,81 @@ void s390_reset_cmma(struct mm_struct *mm)
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(s390_reset_cmma);
> =C2=A0
> -/*
> - * make inaccessible pages accessible again
> - */
> -static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 unsigned long next, struct mm_walk *walk)
> +#define DESTROY_LOOP_THRESHOLD 32

maybe GATHER_NUM_PAGE_REFS_TO_TAKE?
