Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27FB23BCCE
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 16:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgHDO7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 10:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgHDO7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 10:59:22 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D07021744;
        Tue,  4 Aug 2020 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596553162;
        bh=hDrp69Ge8duBMkXKlFgRT0K7orfs6BfaN5WSuwsDUB4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nJ30eHlkodMyfOaGw2JuN5oUUBfc8+g3uBJTnq6VlqKGfg4aRAeDP+MX+u10Dp3WF
         Am5DQhU6IR8I7b9M5/v90ZeFupsb76Fv0q70F2ITw2+2grexrARMo5wfJWkR41ZDjp
         xpDUI8XrlHmNucGch9ee8Fn3voT6Cr482Dx6NSrE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k2yPQ-00HPuB-Jj; Tue, 04 Aug 2020 15:59:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 Aug 2020 15:59:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-Reply-To: <87r1smmpw5.fsf@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org> <87r1smmpw5.fsf@linaro.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <b78f8715bbaec8fc728a85d614b00688@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-04 15:44, Alex Bennée wrote:
> Marc Zyngier <maz@kernel.org> writes:
> 
>> On 2020-08-04 13:44, Alex Bennée wrote:
>>> The VIRTIO_PCI support is an idealised PCI bus, we don't need a bunch
>>> of bloat for real world hardware for a VirtIO guest.
>> 
>> Who says this guest will only have virtio devices?
> 
> This is true - although what is the point of kvm_guest.config? We
> certainly turn on a whole bunch of virt optimised pathways with 
> PARAVIRT
> and HYPERVISOR_GUEST along with the rest of VirtIO.

Most of which actually qualifies as bloat itself as far as KVM/arm64
is concerned...

          M.
-- 
Jazz is not dead. It just smells funny...
