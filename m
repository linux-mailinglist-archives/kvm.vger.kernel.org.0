Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAAF23BEB6
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgHDRQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbgHDRQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 13:16:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B8F207FC;
        Tue,  4 Aug 2020 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596561392;
        bh=KgUSQXHnQmyfVqBx7P8DiLDgLrGMLQ5sEeXPjkKaMgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=po6Awiu2jyPPa8K7P1obOSX43I7xN26lmV3hDkANXkQYWOVML8pKHGk7i8bZvGsXJ
         C7YOUuBeHSAf5ybIvPArid5p2sVn2opD172H2vkd7LXJ3RBWN+wElJAYGQ02xwutbi
         T1rDroNvCn5e/s/uutC20fI/FKFmzW8QVPCvkUro=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k30YA-00HReQ-IA; Tue, 04 Aug 2020 18:16:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 Aug 2020 18:16:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-Reply-To: <87lfiumnc8.fsf@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org> <87r1smmpw5.fsf@linaro.org>
 <b78f8715bbaec8fc728a85d614b00688@kernel.org> <87lfiumnc8.fsf@linaro.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <dd535598ec1886f93f374ed5720b6c74@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-04 16:40, Alex Bennée wrote:
> Marc Zyngier <maz@kernel.org> writes:
> 
>> On 2020-08-04 15:44, Alex Bennée wrote:
>>> Marc Zyngier <maz@kernel.org> writes:
>>> 
>>>> On 2020-08-04 13:44, Alex Bennée wrote:
>>>>> The VIRTIO_PCI support is an idealised PCI bus, we don't need a 
>>>>> bunch
>>>>> of bloat for real world hardware for a VirtIO guest.
>>>> 
>>>> Who says this guest will only have virtio devices?
>>> 
>>> This is true - although what is the point of kvm_guest.config? We
>>> certainly turn on a whole bunch of virt optimised pathways with
>>> PARAVIRT
>>> and HYPERVISOR_GUEST along with the rest of VirtIO.
>> 
>> Most of which actually qualifies as bloat itself as far as KVM/arm64
>> is concerned...
> 
> So here is the question - does the kernel care about having a blessed
> config for a minimal viable guest? They are certainly used in the cloud
> but I understand the kernel is trying to get away from having a zoo of
> configs. What is the actual point of kvm_guest.config? Just an easy
> enabling for developers?

The cloud vendor I know certainly doesn't provide a "dumbed down"
kernel configuration. What they run is either a distro kernel
or something that fits their environment (which does include
HW PCI devices, and hardly any virtio device).

My take is that this kvm-special config isn't that useful in
the real world, and I don't believe there is such thing as a
"minimal viable guest" config, certainly not across architectures
and VMMs. Hopefully it fits someone's development workflow, but
that's probably it.

          M.
-- 
Jazz is not dead. It just smells funny...
