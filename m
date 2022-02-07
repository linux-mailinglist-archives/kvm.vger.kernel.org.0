Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289894AC830
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiBGSDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242021AbiBGR7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:59:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A72C6C0401E0
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 09:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644256789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TOOlPRZ0xgNmF7qWPstueWUd0uJiiuUbMUMYux77ocM=;
        b=aKfZxCwpViCKpn/W5cdbP3D/mPyLuWe1X8fW/T8+a0xkZM+dWBwrd5WoLzS1yS0qXMsC/N
        VdfxIH42S/VYwugw2P/rnzTsGPIy/JyG2ZdxoCUPg9uqQuZ4eigf3uQBa/zdjq9U3mspFB
        ettyOAIhIfZZ4nG4OUg/es6IQjLQTj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-C-rhQO6xM56QfDrHTpRraw-1; Mon, 07 Feb 2022 12:59:46 -0500
X-MC-Unique: C-rhQO6xM56QfDrHTpRraw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF79E8143EF;
        Mon,  7 Feb 2022 17:59:43 +0000 (UTC)
Received: from localhost (unknown [10.39.193.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C7F07747C;
        Mon,  7 Feb 2022 17:59:21 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 14/30] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
In-Reply-To: <1ff6e06c-e563-2b9c-3196-542fed7df0f9@linux.ibm.com>
Organization: Red Hat GmbH
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-15-mjrosato@linux.ibm.com>
 <87czjzvztw.fsf@redhat.com>
 <1ff6e06c-e563-2b9c-3196-542fed7df0f9@linux.ibm.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 07 Feb 2022 18:59:19 +0100
Message-ID: <87sfsuv9qg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 07 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 2/7/22 3:35 AM, Cornelia Huck wrote:
>> On Fri, Feb 04 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>> 
>>> This was previously removed as unnecessary; while that was true, subsequent
>>> changes will make KVM an additional required component for vfio-pci-zdev.
>>> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
>>> to say 'n' for it (when not planning to CONFIG_KVM).
>> 
>> Hm... can the file be split into parts that depend on KVM and parts that
>> don't? Does anybody ever use vfio-pci on a non-kvm s390 system?
>> 
>
> It is possible to split out most of the prior CLP/ vfio capability work 
> (but it would not be a totally clean split, zpci_group_cap for example 
> would need to have an inline ifdef since it references a KVM structure) 
> -- I suspect we'll see more of that in the future.
> I'm not totally sure if there's value in the information being provided 
> today -- this CLP information was all added specifically with 
> userspace->guest delivery in mind.  And to answer your other question, 
> I'm not directly aware of non-kvm vfio-pci usage on s390 today; but that 
> doesn't mean there isn't any or won't be in the future of course.  With 
> this series, you could CONFIG_KVM=n + CONFIG_VFIO_PCI=y|m and you'll get 
> the standard vfio-pci support but never any vfio-pci-zdev extension.

Yes. Remind me again: if you do standard vfio-pci without the extensions
grabbing some card-specific information and making them available to the
guest, you get a working setup, it just always looks like a specific
card, right?

>
> If we wanted to provide everything we can where KVM isn't strictly 
> required, then let's look at what a split would look like:
>
> With or without KVM:
> zcpi_base_cap
> zpci_group_cap (with an inline ifdef for KVM [1])
> zpci_util_cap
> zpci_pfip_cap
> vfio_pci_info_zdev_add_caps	
> vfio_pci_zdev_open (ifdef, just return when !KVM  [1])
> vfio_pci_zdev_release (ifdef, just return when !KVM [1])
>
> KVM only:
> vfio_pci_zdev_feat_interp
> vfio_pci_zdev_feat_aif
> vfio_pci_zdev_feat_ioat
> vfio_pci_zdev_group_notifier
>
> I suppose such a split has the benefit of flexibility / 
> future-proofing...  should a non-kvm use case arrive in the future for 
> s390 and we find we need some s390-specific handling, we're still 
> building vfio-pci-zdev into vfio-pci by default and can just extend that.
>
> [1] In this case I would propose renaming CONFIG_VFIO_PCI_ZDEV as we 
> would once again always be building some part of vfio-pci-zdev with 
> vfio-pci on s390 -- maybe something like CONFIG_VFIO_PCI_ZDEV_KVM (wow 
> that's a mouthful) and then use this setting to check "KVM" in my above 
> split.  Since this setting will imply PCI, VFIO_PCI and KVM, we can then 
> s/CONFIG_VFIO_PCI_ZDEV/CONFIG_VFIO_PCI_ZDEV_KVM/ for the rest of the 
> series (to continue covering cases like we build KVM but not pci, or not 
> vfio-pci)
>
> How does that sound?

Complex :)

I'm not really sure whether it's worth the hassle on an odd chance that
we may want it for a !KVM usecase in the future (that goes beyond the
"base" vfio-pci support.) OTOH, it would be cleaner. I'm a bit torn on
this one.

