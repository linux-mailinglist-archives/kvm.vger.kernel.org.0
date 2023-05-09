Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561836FC9A0
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbjEIOyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbjEIOya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:54:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAA41FF7;
        Tue,  9 May 2023 07:54:28 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349Ei8Ci022208;
        Tue, 9 May 2023 14:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=/HKDCCuHAp5TSzvvd/574zZjRR+zOpPUfKXxEXDrlT0=;
 b=TywvbyPtmlyveuhzIWnzzOTbB4WPQCHZfZmkYoTAA+spZBuDbmXxPzQZdv3sWJmy+eQH
 emK8efGDtLCaEgI02lvj0o0UKYT9YV2+9BHD+SENnbYZfgO6I6IjwKdDtbtT+XPn17hU
 Wu9U1yJXZ2VNbY0LUfY/4Dy7Yvw8KJpmQBTG6uNWrSztr3kUJip3b/YrKONLMrzY9hBb
 lKEgsIUMEhdFSv+yhsQCvK6OewOuT2ze7R22ESQ3/umDIySR+skx3/yN1TfLgTNM0u3B
 PeawMNozKSjAPNaaLdQBoYG0V4TAhF7FytVZ49NiitpcZc7kA/IJ9yATCBjKLEWTGPsn Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfr6p0cyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:54:27 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349Ej1O9026731;
        Tue, 9 May 2023 14:54:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfr6p0cxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:54:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3492j224021669;
        Tue, 9 May 2023 14:54:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qf7nh0gxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 14:54:25 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349EsLlV66847086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 14:54:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8404F20043;
        Tue,  9 May 2023 14:54:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62A2B20040;
        Tue,  9 May 2023 14:54:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.4.21])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 14:54:21 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c762bd30-9753-7b3e-3f46-b15ba575ee7c@linux.ibm.com>
References: <20230509111202.333714-1-nrb@linux.ibm.com> <20230509111202.333714-3-nrb@linux.ibm.com> <c762bd30-9753-7b3e-3f46-b15ba575ee7c@linux.ibm.com>
Subject: Re: [PATCH v1 2/3] KVM: s390: add stat counter for shadow gmap events
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com
Message-ID: <168364406109.331309.632943177292737298@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 09 May 2023 16:54:21 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EEKFMrMEGysHR1BmWbrkhoWocotqtrQX
X-Proofpoint-ORIG-GUID: fV2Txv9b6J9rRp0icZ0ubvDjn6mb2T5h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-09 13:59:46)
[...]
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> > index 3c3fe45085ec..7f70e3bbb44c 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -777,6 +777,11 @@ struct kvm_vm_stat {
> >       u64 inject_service_signal;
> >       u64 inject_virtio;
> >       u64 aen_forward;
> > +     u64 gmap_shadow_acquire;
> > +     u64 gmap_shadow_r2;
> > +     u64 gmap_shadow_r3;
> > +     u64 gmap_shadow_segment;
> > +     u64 gmap_shadow_page;
>=20
> This needs to be gmap_shadow_pgt and then we need a separate shadow page =

> counter that's beeing incremented in kvm_s390_shadow_fault().
>=20
>=20
> I'm wondering if we should name them after the entries to reduce=20
> confusion especially when we get huge pages in the future.
>=20
> gmap_shadow_acquire
> gmap_shadow_r1_te (ptr to r2 table)
> gmap_shadow_r2_te (ptr to r3 table)
> gmap_shadow_r3_te (ptr to segment table)
> gmap_shadow_sg_te (ptr to page table)
> gmap_shadow_pg_te (single page table entry)

Yep, right, this was highly confusing to the point where I was also
confused by it. Will change that, thanks.
