Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E21782F6E
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjHURar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbjHURaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:30:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0006D124
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AEAE63B41
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 17:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8339C433C9;
        Mon, 21 Aug 2023 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692639031;
        bh=SfyXt+e5RJK+sTZlB9Ncbo3gaHqnWHAg7lpQwU3xZlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N0SznYOQd7GlX5kumiH/I/OiJgAz6XAxocEt5lu9BwvxI7vN/ZgqV9lWiD9PiwVEm
         Vr173EiYI7LSSFGO9U45TrJBjgAyACeHdhvrz3XJRrfi6TF2B0cqjU/oFkjMfpSG7D
         nb4cg7KMWbWM67wLuTV2l1AFz+8vAQ+uBgni71Ij4uC0XIehcWJ0+kc8VkZ8NiGJoD
         5aVM52TSvLPO+FXv3hi90a7GHP1Rd4z4Jf8bfdwf05gUUTj3FYP4Cftb/zwjNlxBXk
         r74r5oFiGCxjvsziZfQXi0sDTnreUz3cdqoPb5S9QUFqc0UiAJvND87Hj7PAZ5rpHG
         1FL9OH74b+Khg==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qY8jV-006mxX-6r;
        Mon, 21 Aug 2023 18:30:29 +0100
MIME-Version: 1.0
Date:   Mon, 21 Aug 2023 18:30:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH v8 02/11] KVM: arm64: Document
 KVM_ARM_GET_REG_WRITABLE_MASKS
In-Reply-To: <CAAdAUtjG-9Ttdk3_T+OV6ea3p_r9q0yrE1XJUpdB0PwSJsN6VA@mail.gmail.com>
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-3-jingzhangos@google.com>
 <878raex8g0.fsf@redhat.com>
 <CAAdAUtivsxqpSE_0BL_OftxzwR=e5Rnugb69Ln841ooJqVXgmA@mail.gmail.com>
 <874jkyqe13.fsf@redhat.com> <86sf8hg45k.wl-maz@kernel.org>
 <CAAdAUtjG-9Ttdk3_T+OV6ea3p_r9q0yrE1XJUpdB0PwSJsN6VA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <da71d814ea1c9485c523b0d823281ff5@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: jingzhangos@google.com, cohuck@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, will@kernel.org, pbonzini@redhat.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, tabba@google.com, reijiw@google.com, rananta@google.com, surajjs@amazon.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-08-21 18:24, Jing Zhang wrote:
> On Thu, Aug 17, 2023 at 7:00 AM Marc Zyngier <maz@kernel.org> wrote:
>> 
>> On Thu, 17 Aug 2023 09:16:56 +0100,
>> Cornelia Huck <cohuck@redhat.com> wrote:
>> >
>> > On Mon, Aug 14 2023, Jing Zhang <jingzhangos@google.com> wrote:
>> >
>> > > Maybe it'd be better to leave this to whenever we do need to add other
>> > > range support?
>> >
>> > My point is: How does userspace figure out if the kernel that is running
>> > supports ranges other than id regs? If this is just an insurance against
>> > changes that might arrive or not, we can live with the awkward "just try
>> > it out" approach; if we think it's likely that we'll need to extend it,
>> > we need to add the mechanism for userspace to find out about it now, or
>> > it would need to probe for presence of the mechanism...
>> 
>> Agreed. Nothing like the present to address this sort of things. it
>> really doesn't cost much, and I'd rather have it right now.
>> 
>> Here's a vague attempt at an advertising mechanism. If people are OK
>> with it, I can stash that on top of Jing's series.

[...]

> Looks good to me.

Well, that's of course conditional on the other comments
I made against this series. And we're seriously running
out of time...

         M.
-- 
Jazz is not dead. It just smells funny...
