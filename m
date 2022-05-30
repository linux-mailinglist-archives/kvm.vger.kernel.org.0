Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C785C537A56
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 14:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiE3MF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiE3MFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 08:05:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F99251E71;
        Mon, 30 May 2022 05:05:24 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UBBn5W023475;
        Mon, 30 May 2022 12:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=D6pExEEiOP01k4g5hzXLFiw9QdYkFueNgR/mF/w6Gp4=;
 b=jW5bfeff7IZQlczrzCE87EtjreggWePFyDkC0mPX8MM33ATDAfywXPYpW12K6Ul5XZiE
 nFrtlRsnzqCNkxtVY+zKjfl51RYqf4wqKfDFje4Nc27EPDwOj8ITtvw65/78o1NtGia4
 X4YvIkdbyP/9DpQYFQF6bG863OCOpZXNo9f6SiKCpeZxsnFk8fDRRJBGvcnlKrFyd1jo
 XdnZlt1Tol4TVXcY83kvsBFJezzBfyMXpvmZCBsfS9jSYh0u5kLWJ5hHxuQZuYjShEPi
 +AwCtr2XiDxHiMe7ae1fBFTAbLE4jUGX27+OWQWO5DgHJ8EGPd4WUw31Ood3tcEJkrDd Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcvua8wb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 12:05:23 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UBXCeW008700;
        Mon, 30 May 2022 12:05:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcvua8wa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 12:05:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UC50qa016286;
        Mon, 30 May 2022 12:05:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h2p34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 12:05:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UC5H7V28377588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 12:05:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8686A4053;
        Mon, 30 May 2022 12:05:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E9C2A4040;
        Mon, 30 May 2022 12:05:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 12:05:16 +0000 (GMT)
Date:   Mon, 30 May 2022 14:05:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v10 13/19] KVM: s390: pv: destroy the configuration
 before its memory
Message-ID: <20220530140514.74f6ea46@p-imbrenda>
In-Reply-To: <96ee2d8c2c64b4968529b78bd7ad8a042542d353.camel@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-14-imbrenda@linux.ibm.com>
        <96ee2d8c2c64b4968529b78bd7ad8a042542d353.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Ejm7-gaFFx-nbxjBNCBc8d3jX_4zNzs
X-Proofpoint-GUID: X8Zaa9OTDvG1rN-58Fref4ZqLVp-mSKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 09:37:37 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
> > Move the Destroy Secure Configuration UVC before the loop to destroy
> > the memory. If the protected VM has memory, it will be cleaned up and
> > made accessible by the Destroy Secure Configuraion UVC. The struct
> > page for the relevant pages will still have the protected bit set, so
> > the loop is still needed to clean that up.
> >=20
> > Switching the order of those two operations does not change the
> > outcome, but it is significantly faster.
> >=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com> =20
>=20
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> See one tiny thing below.
>=20
> > diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> > index be3b467f8feb..bd850be08c86 100644
> > --- a/arch/s390/kvm/pv.c
> > +++ b/arch/s390/kvm/pv.c =20
> [...]
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cc =3D uv_cmd_nodata(kvm_s39=
0_pv_get_handle(kvm),
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WRITE_ONCE(kvm->arch.gm=
ap->guest_handle, 0); =20
>=20
> Maybe it makes sense to also move the WRITE_ONCE up.

yes, I'll move it up, so that it is right after the UVC again


