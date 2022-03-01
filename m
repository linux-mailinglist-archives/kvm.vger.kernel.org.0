Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0F4C8ACE
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 12:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiCALcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 06:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiCALcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 06:32:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 284C348330
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 03:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646134301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=00HQH/gJk4+FkSrUA5MwoQnd1kXjVciWiqxvQ3N3LN4=;
        b=iYIAihlgDLIK6HlQ+qZFgpofsxmzbLSbluAu/sYGk+UQPiGIITkALy5TeKxbl7Io/VaE9S
        EjJ552zg3lDZqzn4IVZUtCY5mE3itChSkHuOiBoA7et4FmUmvfWauBxNbcyK+1I0ebKriK
        +t3DwDyVJJNAEsyiO1gvFcDhqUJOBeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-TpH5T0knOb6iwZWOhY6vPg-1; Tue, 01 Mar 2022 06:31:38 -0500
X-MC-Unique: TpH5T0knOb6iwZWOhY6vPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2BADFC80;
        Tue,  1 Mar 2022 11:31:36 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13E1576115;
        Tue,  1 Mar 2022 11:31:33 +0000 (UTC)
Message-ID: <264f1282c315dd66cd34cfb74f71f53fe3c84126.camel@redhat.com>
Subject: Re: [RFC PATCH 05/13] KVM: SVM: Update max number of vCPUs
 supported for x2AVIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 01 Mar 2022 13:31:32 +0200
In-Reply-To: <c17e954b-0f62-e0ad-77f0-1429dcc94f6d@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-6-suravee.suthikulpanit@amd.com>
         <9143d9d24d1b169668062a18a5f49bb8cf8e877b.camel@redhat.com>
         <c17e954b-0f62-e0ad-77f0-1429dcc94f6d@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-01 at 17:47 +0700, Suravee Suthikulpanit wrote:
> Hi Maxim,
> 
> On 2/25/22 12:18 AM, Maxim Levitsky wrote:
> > On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
> > > xAVIC and x2AVIC modes can support diffferent number of vcpus.
> > > Update existing logics to support each mode accordingly.
> > > 
> > > Also, modify the maximum physical APIC ID for AVIC to 255 to reflect
> > > the actual value supported by the architecture.
> > > 
> > > Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
> > > ---
> > >   arch/x86/include/asm/svm.h | 12 +++++++++---
> > >   arch/x86/kvm/svm/avic.c    |  8 +++++---
> > >   2 files changed, 14 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > index 7a7a2297165b..681a348a9365 100644
> > > --- a/arch/x86/include/asm/svm.h
> > > +++ b/arch/x86/include/asm/svm.h
> > > @@ -250,10 +250,16 @@ enum avic_ipi_failure_cause {
> > >   
> > >   
> > >   /*
> > > - * 0xff is broadcast, so the max index allowed for physical APIC ID
> > > - * table is 0xfe.  APIC IDs above 0xff are reserved.
> > > + * For AVIC, the max index allowed for physical APIC ID
> > > + * table is 0xff (255).
> > >    */
> > > -#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
> > > +#define AVIC_MAX_PHYSICAL_ID		0XFFULL
> > > +
> > > +/*
> > > + * For x2AVIC, the max index allowed for physical APIC ID
> > > + * table is 0x1ff (511).
> > > + */
> > > +#define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
> > Yep, physid page can't hold more entries...
> > 
> > This brings the inventible question of what to do when a VM has more
> > that 512 vCPUs...
> > 
> > With AVIC, since it is xapic, it would be easy - xapic supports up to
> > 254 CPUs.
> 
> Actually, 255 vCPUs.

Sorry for off-by-one mistake - just remembered that 0xFF is reserved,
but then 255 is already 1 less that 256.

> 
> > But with x2apic, there is no such restriction on max 512 CPUs,
> > thus it is legal to create a VM with x2apic and more that 512 CPUs,
> > and x2AVIC won't work well in this case.
> > 
> > I guess AVIC_IPI_FAILURE_INVALID_TARGET, has to be extened to support those
> > cases, even with loss of performance, or we need to inhibit x2AVIC.
> 
> In case of x2APIC-enabled guest w/ vCPU exceeding the max APIC ID (512) limit,
> the ioctl operation for KVM_CREATE_VCPU will fail. For QEMU, this would
> exit with error code. Would this be sufficient?
Yes, this is the best.


Best regards,
	Maxim Levitsky


> 
> Regards,
> Suravee
> 
> 
> 


