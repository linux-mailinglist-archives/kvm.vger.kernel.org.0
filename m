Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16CA29E187
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 03:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgJ2CBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 22:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgJ1Vt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 17:49:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA867C0613D3;
        Wed, 28 Oct 2020 14:49:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603919633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZN7gTMaQE9rZtoF/3JClNUhpDPOWII3Z0v/zsk1pW7Y=;
        b=DvOqsTCfJb//Gu7QniTg8aS3rdwxklw2TVI+sHxcDpoVjSql6wCXVQXYegUolgA+d1mElE
        tbylmYcxS3byoU49CeslFOqrj1SYPqXk00NPmWPVNsNwpSvKMJbJ7jx2c7G4WRXXhIFAC+
        CPeUOshJVPkcBe0C4CLLDINzO4Ec0dvdzld+HhYYl+S82ZxoHUg/xsH9fGPq22aoDNGL/K
        mhGheXQunw7P8/igcnAToSOwKUisFT9x6VVPdFHJvbqpamRoRYUcy7ziiLKenlaGpxR3+0
        0crL/f5reEyrGLxAE4MFUM+fQBN8sakeQnHRmtIKDhu6afo1sUoigwWkXXdIow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603919633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZN7gTMaQE9rZtoF/3JClNUhpDPOWII3Z0v/zsk1pW7Y=;
        b=R8WZe//0NE888iRDVHM3pZcAHWnxRbe/zZzK4/MnQh4TllKWr+JrVaCiEyALu4243gwqiZ
        Q37ahmWu/3/IosDA==
To:     Kees Cook <keescook@chromium.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     x86@kernel.org, kvm <kvm@vger.kernel.org>,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v3 15/35] PCI: vmd: Use msi_msg shadow structs
In-Reply-To: <202010281347.2943F5B7@keescook>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org> <20201024213535.443185-1-dwmw2@infradead.org> <20201024213535.443185-16-dwmw2@infradead.org> <202010281347.2943F5B7@keescook>
Date:   Wed, 28 Oct 2020 22:13:52 +0100
Message-ID: <87blgmf3zj.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 28 2020 at 13:49, Kees Cook wrote:
> On Sat, Oct 24, 2020 at 10:35:15PM +0100, David Woodhouse wrote:
>> +	memset(&msg, 0, sizeof(*msg);
>
> This should be:
>
> +	memset(msg, 0, sizeof(*msg);

        memset(msg, 0, sizeof(*msg));

Then it compiles _and_ is correct :)
