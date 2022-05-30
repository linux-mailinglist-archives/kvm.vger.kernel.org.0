Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC353758F
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 09:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiE3HiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 03:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiE3Hhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 03:37:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36ED71DB4;
        Mon, 30 May 2022 00:37:44 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U6GHaG026664;
        Mon, 30 May 2022 07:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=2x1TC/lV7sFdGeMYAlrgQ/GiPxyjwkcnYZuJEIQYjCw=;
 b=K9V67GwPy/X/WBnScG9C3Cv15dCDT3gWQPOq3AzpHFVr3NNdymniBTb5HYz1Fyf4Lqd+
 kiVYAwQuSHUqBsrb0UuYqbLVjL2wyMEJPwsTn7ok8mFW3cOpmdC/awQAwT4B7o8WPaK2
 qMCt9TrCQYnkm5oGJwZbq38jgVmPeirmNhH6QQfQX4AbV9VzrMsa3YWgioeh9j3T6Tkf
 5J0jaz4Re1440FkcRqQShTjn/ja7DEE9vlotBZB3KZOKyBWPo/ijgNy4rhC4cK7IQ2xN
 4rZ7P8gzrQzLIfc5hHfSrOXlwYxYDHlMRxlqAEL9BgJHYKH8YHAw0cOr8VU2tqVUk+4Z aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcrgpscw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 07:37:43 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U7XrmX020012;
        Mon, 30 May 2022 07:37:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcrgpscvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 07:37:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U7J5Pg002807;
        Mon, 30 May 2022 07:37:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3gbbynjb4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 07:37:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U7bcpn16318822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 07:37:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3845642045;
        Mon, 30 May 2022 07:37:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCBF742042;
        Mon, 30 May 2022 07:37:37 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 07:37:37 +0000 (GMT)
Message-ID: <96ee2d8c2c64b4968529b78bd7ad8a042542d353.camel@linux.ibm.com>
Subject: Re: [PATCH v10 13/19] KVM: s390: pv: destroy the configuration
 before its memory
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 30 May 2022 09:37:37 +0200
In-Reply-To: <20220414080311.1084834-14-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-14-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u_qdatLNA22tl79AEDvPCMrYuF3ry-qx
X-Proofpoint-ORIG-GUID: GkGTbdCm_0xTLqL3EMHUcTxQx43sy4RC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_02,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 clxscore=1011 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
> Move the Destroy Secure Configuration UVC before the loop to destroy
> the memory. If the protected VM has memory, it will be cleaned up and
> made accessible by the Destroy Secure Configuraion UVC. The struct
> page for the relevant pages will still have the protected bit set, so
> the loop is still needed to clean that up.
>=20
> Switching the order of those two operations does not change the
> outcome, but it is significantly faster.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

See one tiny thing below.

> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index be3b467f8feb..bd850be08c86 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
[...]
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cc =3D uv_cmd_nodata(kvm_s390_=
pv_get_handle(kvm),
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WRITE_ONCE(kvm->arch.gmap=
->guest_handle, 0);

Maybe it makes sense to also move the WRITE_ONCE up.

