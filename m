Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4DCA58226
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 14:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfF0ME3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 08:04:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbfF0ME3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jun 2019 08:04:29 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RBwEUS098232
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 08:04:28 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcvwpsubs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 08:04:28 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 27 Jun 2019 13:04:25 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 13:04:23 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RC4L9026018156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 12:04:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 190C3A4066;
        Thu, 27 Jun 2019 12:04:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA0B8A4067;
        Thu, 27 Jun 2019 12:04:20 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.115])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 12:04:20 +0000 (GMT)
Date:   Thu, 27 Jun 2019 14:04:19 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        frankja@linux.ibm.com, akrowiak@linux.ibm.com, david@redhat.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v9 4/4] s390: ap: kvm: Enable PQAP/AQIC facility for the
 guest
In-Reply-To: <69ca50bd-3f5c-98b1-3b39-04af75151baf@de.ibm.com>
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
        <1558452877-27822-5-git-send-email-pmorel@linux.ibm.com>
        <69ca50bd-3f5c-98b1-3b39-04af75151baf@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062712-0020-0000-0000-0000034DE34E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062712-0021-0000-0000-000021A15DED
Message-Id: <20190627140419.1df5f519.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jun 2019 22:13:12 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 
> 
> On 21.05.19 17:34, Pierre Morel wrote:
> > AP Queue Interruption Control (AQIC) facility gives
> > the guest the possibility to control interruption for
> > the Cryptographic Adjunct Processor queues.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > ---
> >  arch/s390/tools/gen_facilities.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
> > index 61ce5b5..aed14fc 100644
> > --- a/arch/s390/tools/gen_facilities.c
> > +++ b/arch/s390/tools/gen_facilities.c
> > @@ -114,6 +114,7 @@ static struct facility_def facility_defs[] = {
> >  		.bits = (int[]){
> >  			12, /* AP Query Configuration Information */
> >  			15, /* AP Facilities Test */
> > +			65, /* AP Queue Interruption Control */
> >  			156, /* etoken facility */
> >  			-1  /* END */
> >  		}
> > 
> 
> I think we should only set stfle.65 if we have the aiv facility (Because we do not
> have a GISA otherwise)
> 
> So something like this instead?
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 28ebd64..1501cd6 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2461,6 +2461,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>                 set_kvm_facility(kvm->arch.model.fac_list, 147);
>         }
>  
> +       if (css_general_characteristics.aiv)
> +               set_kvm_facility(kvm->arch.model.fac_mask, 65);
> +       
>         kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
>         kvm->arch.model.ibc = sclp.ibc & 0x0fff;

I will go with this option because it is more readable (easier to find)
IMHO. Will also add a chech for host sltfle.65. So I end up with:

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 28ebd647784c..1c4113f0f2a8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2461,6 +2461,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
                set_kvm_facility(kvm->arch.model.fac_list, 147);
        }
 
+       if (css_general_characteristics.aiv && test_facility(65))
+               set_kvm_facility(kvm->arch.model.fac_mask, 65);
+
        kvm->arch.model.cpuid = kvm_s390_get_initial_cpuid();
        kvm->arch.model.ibc = sclp.ibc & 0x0fff;
 
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index d52f537b7169..cead9e0dcffb 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -111,7 +111,6 @@ static struct facility_def facility_defs[] = {
                .bits = (int[]){
                        12, /* AP Query Configuration Information */
                        15, /* AP Facilities Test */
-                       65, /* AP Queue Interruption Control */
                        156, /* etoken facility */
                        -1  /* END */


