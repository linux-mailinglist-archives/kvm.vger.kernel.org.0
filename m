Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3713F0B4A
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhHRSwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:52:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56262 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232676AbhHRSwj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 14:52:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IIZOjj097790;
        Wed, 18 Aug 2021 14:51:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=bhlerqPzxKDsl5WHelFKWWyiLBMMmsCeRU/M1mVJyH0=;
 b=h1WI4H21SdXczB1KHk3NbOahHjdAscSjQGsKYXXawrfYsWL0By3EkV/etAgOWdZ/WD7U
 RHauODwyO/zKGMo6A0lZPA+UIag2I6nuMOelPh8jntzOWi+lQHyccWfLdyoYvD2J99ya
 hf9AFOOqdABFJfN8Lz0SJ1q16DWv/MFRIoGoLSz/nHnqHiHGEgc49yF1E2VVXw/AIvae
 XGC029oGESOnhHu20Te6od6j5egTPuezGSiE5f/63/sVRUOoaXjxT8SEU5aDdgwLtM1U
 BnMoToRnszWpdPd/5DSsd2wspUe9np7xje/L8AsAHgsLPHynxrAOkaN1jssIXaY+bnTm 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1ywqae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 14:51:57 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IIa4Q7104833;
        Wed, 18 Aug 2021 14:51:56 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agp1ywqa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 14:51:56 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IIWHRR027267;
        Wed, 18 Aug 2021 18:51:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 3ae5fdhdbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 18:51:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IIpskK53477640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 18:51:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 945977807E;
        Wed, 18 Aug 2021 18:51:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D398C7805C;
        Wed, 18 Aug 2021 18:51:51 +0000 (GMT)
Received: from [10.50.3.223] (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 18:51:51 +0000 (GMT)
Message-ID: <bc11c76e083784537a8ceaf8d3d2f74b5ca9e655.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, mst@redhat.com, richard.henderson@linaro.org,
        tobin@ibm.com, dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        kvm@vger.kernel.org
Date:   Wed, 18 Aug 2021 14:51:50 -0400
In-Reply-To: <YR1Dnl6kDjsz+gWI@work-vm>
References: <20210816144413.GA29881@ashkalra_ubuntu_server>
         <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
         <20210816151349.GA29903@ashkalra_ubuntu_server>
         <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
         <20210818103147.GB31834@ashkalra_ubuntu_server>
         <f0b5b725fc879d72c702f88a6ed90e956ec32865.camel@linux.ibm.com>
         <YR0nwVPKymrAeIzV@work-vm>
         <8ae11fca26e8d7f96ffc7ec6353c87353cadc63a.camel@linux.ibm.com>
         <YR0qoV6tDuVxddL5@work-vm>
         <8a94ce57b4aa28df1504dcf08aace88d594ffb32.camel@linux.ibm.com>
         <YR1Dnl6kDjsz+gWI@work-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x-45Xgu6qoWXHlQTR3NofZmC10lFf2er
X-Proofpoint-GUID: c7KHo02ECctrgq7sFpC_LzDmd3sKXJ0m
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_07:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-08-18 at 18:30 +0100, Dr. David Alan Gilbert wrote:
> * James Bottomley (jejb@linux.ibm.com) wrote:
> > On Wed, 2021-08-18 at 16:43 +0100, Dr. David Alan Gilbert wrote:
> > > * James Bottomley (jejb@linux.ibm.com) wrote:
> > [...]
> > > > Given the lack of SMI, we can't guarantee that with plain SEV
> > > > and -ES. Once we move to -SNP, we can use VMPLs to achieve
> > > > this.
> > > 
> > > Doesn't the MH have access to different slots and running on
> > > separate vCPUs; so it's still got some separation?
> > 
> > Remember that the OVMF code is provided by the host, but its
> > attested to and run by the guest.  Once the guest takes control
> > (i.e. after OVMF boots the next thing), we can't guarantee that it
> > wont overwrite the MH code, so the host must treat the MH as
> > untrusted.
> 
> Yeh; if it's in a romimage I guess we could write protect it?
> (Not that I'd trust it still)

Yes, but unfortunately OVMF (and edk2 in general) has another pitfall
for you: the initial pflash may be a read only ROM image, but it
uncompresses itself to low RAM and executes itself out of there. 
Anything in either PEI or DXE (which is where the migration handler
lies) is RAM based after decompression.

> > > > But realistically, given the above API, even if the guest is
> > > > malicious, what can it do?  I think it's simply return bogus
> > > > pages that cause a crash on start after migration, which
> > > > doesn't look like a huge risk to the cloud to me (it's more a
> > > > self destructive act on behalf of the guest).
> > > 
> > > I'm a bit worried about the data structures that are shared
> > > between the migration code in qemu and the MH; the code in qemu
> > > is going to have to be paranoid about not trusting anything
> > > coming from the MH.
> > 
> > Given that we have to treat the host MH structure as untrusted,
> > this is definitely something we have to do.  Although the primary
> > API is simply "here's a buffer, please fill it", so there's not
> > much checking to do, we just have to be careful that we don't
> > expose any more of the buffer than the guest needs to write to ...
> > and, obviously, clean it before exposing it to the guest.
> 
> I was assuming life got a bit more complicated than that; and we had
> to have lists of pages we were requesting, and a list of pages that
> were cooked and the qemu thread and the helper thread all had to work
> in parallel.  So I'm guessing some list or bookkeeeping that we need
> to be very careful of.

I was more or less imagining a GPA address and length, so range based,
but it could be we need something more sophisticated ... Tobin will
look after that part.  However, either way, we just need to be careful.

Regards,

James


