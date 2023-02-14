Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80593696007
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 10:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjBNJ7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 04:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjBNJ7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 04:59:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1B725B98;
        Tue, 14 Feb 2023 01:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7BF96150D;
        Tue, 14 Feb 2023 09:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3C5C433D2;
        Tue, 14 Feb 2023 09:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676368699;
        bh=OU9XaxlzIQNm9uPoSElC+25TvF2PsT501YwBQ7EdhCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZNIpNVUu5NKWJ2OPxfSC7tnHbL6lgxuXuwdPCP5gl5gWBFxbVTdAACSmagfVWjewx
         O7m9GYOYk/+lrirlWzbu6Ro/o43n/tVE1Nr/c185YifxFrNyumd3rUbfeCrMmojOTM
         JfuOyFlOb1riQJV7vPBx4NDF2QOuzQiaAGqXjHtc=
Date:   Tue, 14 Feb 2023 10:58:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH v1 01/24] LoongArch: KVM: Implement kvm module related
 interface
Message-ID: <Y+tbMwXjA0hkiUJA@kroah.com>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
 <20230214025648.1898508-2-zhaotianrui@loongson.cn>
 <Y+ssT+W27GxDRAAZ@kroah.com>
 <6fd2ca5a-7243-0627-79e9-8c8bd840adc2@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fd2ca5a-7243-0627-79e9-8c8bd840adc2@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 05:00:56PM +0800, Tianrui Zhao wrote:
> > > +#define KVM_GET_CSRS		_IOWR(KVMIO, 0xc5, struct kvm_csrs)
> > > +#define KVM_SET_CSRS		_IOW(KVMIO,  0xc6, struct kvm_csrs)
> > Why does this arch need new ioctls?
> We want to use this ioctl to access multiple csrs at one time. If without
> this, we only access one csr.

What is wrong with accessing only one csr at a time?  Isn't this what
other architectures do?

> There is another function, can we use the KVM_GET/SET_MSRS to access our
> csrs?

I do not know, that's up to the KVM developers to answer.

thanks,

greg k-h
