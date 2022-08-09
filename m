Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7572658D243
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 05:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiHIDM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 23:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiHIDM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 23:12:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BBF810EA
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 20:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660014774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p7pA+XrnNoTq27MsRVHmfaaizOofAZ0f/q24EJV9Tu8=;
        b=WhcK24e5SO5Xd4LyxLvJk7pjn6hj0IeO+vRjctfS87Ha1vcAZRM0z4qiMCG5MBcnx5oZfc
        5tUYIq0L073vcIkhppC9RHy/Uop1ttARjWlxpYOHBtnyy4uACpMWknnBfiNn1MP9ouFRU6
        5WLc9Nt1bojQlunRWEOaS+Jf9nkqmqc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-EGL5LNcmMS-jbHXatpEJgg-1; Mon, 08 Aug 2022 23:12:52 -0400
X-MC-Unique: EGL5LNcmMS-jbHXatpEJgg-1
Received: by mail-lj1-f197.google.com with SMTP id u7-20020a2e2e07000000b0025e4fbba9f0so3002524lju.13
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 20:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7pA+XrnNoTq27MsRVHmfaaizOofAZ0f/q24EJV9Tu8=;
        b=ef9Yapvq+2YhZEKMeM9q2XfE55Y9l79CI/tAeXrBTXqtg0UQkQ9JMGAsyNxgc97pV5
         cumLtcv2vOkPBwJN1MtomVKDAk75/4GRZXiuL9fRSw0QLl7gWbS5zO2irQbrF4kpvuiU
         x1/iI34A/yJkRygvfAeMZsU6baF1ybZ7Hcbh/JXhAADpnwV9ItVcD2osAdBskAkPXCXM
         WuWoMHq7++qnCxFew6WY3pKWtKzF4S39PvwVWvjFo7pkK/fMrkrEBqmI9fQwORgHR/HG
         EAlraWQxyf4h9fvB/rHdPV6cEsJXMvsj8Fq/Fl9JbdJ+2KarVbeHDukfoJDGobjLa5vQ
         bDcw==
X-Gm-Message-State: ACgBeo1fnKBFAgNrCQnVx2kt5I6Qr9M2Ss6Z09+gunlpPeiw6BPAMfuX
        qvwQnqsmd4XU97ljcMAcABs44GkQCEYr599ponLXcvPDa7rZG3LlJj0Zuhr80jkOPgSgDuHDi1q
        LF8ZwHB8W0RMhHQWnvB3rGZbMjeyp
X-Received: by 2002:a2e:9e17:0:b0:25d:7654:4c6b with SMTP id e23-20020a2e9e17000000b0025d76544c6bmr6972611ljk.130.1660014770551;
        Mon, 08 Aug 2022 20:12:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6boT+iBnbPVgXbWA6rjvFTGc9v5SjET/xDocWM+VDJq5V2uUoZJS7vWnr8ti+xkcDaQh9jq6hAvubkFqcxfHs=
X-Received: by 2002:a2e:9e17:0:b0:25d:7654:4c6b with SMTP id
 e23-20020a2e9e17000000b0025d76544c6bmr6972603ljk.130.1660014770167; Mon, 08
 Aug 2022 20:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220805181105.GA29848@willie-the-truck> <20220807042408-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220807042408-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 9 Aug 2022 11:12:39 +0800
Message-ID: <CACGkMEtd_8gu7nMjLFmw7dcXJ0rvsQYiVcUdi3CaY-DBQ4=JZg@mail.gmail.com>
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Will Deacon <will@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ascull@google.com, Marc Zyngier <maz@kernel.org>,
        Keir Fraser <keirf@google.com>, jiyong@google.com,
        kernel-team@android.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 7, 2022 at 9:14 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Will, thanks very much for the analysis and the writeup!
>
> On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
> > So how should we fix this? One possibility is for us to hack crosvm to
> > clear the VIRTIO_F_ACCESS_PLATFORM flag when setting the vhost features,
> > but others here have reasonably pointed out that they didn't expect a
> > kernel change to break userspace. On the flip side, the offending commit
> > in the kernel isn't exactly new (it's from the end of 2020!) and so it's
> > likely that others (e.g. QEMU) are using this feature.
>
> Exactly, that's the problem.
>
> vhost is reusing the virtio bits and it's only natural that
> what you are doing would happen.
>
> To be precise, this is what we expected people to do (and what QEMU does):
>
>
> #define QEMU_VHOST_FEATURES ((1 << VIRTIO_F_VERSION_1) |
>                              (1 << VIRTIO_NET_F_RX_MRG) | .... )
>
> VHOST_GET_FEATURES(... &host_features);
> host_features &= QEMU_VHOST_FEATURES
> VHOST_SET_FEATURES(host_features & guest_features)
>
>
> Here QEMU_VHOST_FEATURES are the bits userspace knows about.
>
> Our assumption was that whatever userspace enables, it
> knows what the effect on vhost is going to be.
>
> But yes, I understand absolutely how someone would instead just use the
> guest features. It is unfortunate that we did not catch this in time.
>
>
> In hindsight, we should have just created vhost level macros
> instead of reusing virtio ones. Would address the concern
> about naming: PLATFORM_ACCESS makes sense for the
> guest since there it means "whatever access rules platform has",
> but for vhost a better name would be VHOST_F_IOTLB.

Yes, in the original patch it is called VHOST_F_DEVICE_IOTLB actually
to make it differ from virtio like VHOST_F_LOG_ALL etc. And I remember
I tried to post patch to avoid the bit duplication but the conclusion
is that it's too late for the changes.

> We should have also taken greater pains to document what
> we expect userspace to do. I remember now how I thought about something
> like this but after coding this up in QEMU I forgot to document this :(
> Also, I suspect given the history the GET/SET features ioctl and burned
> wrt extending it and we have to use a new when we add new features.
> All this we can do going forward.
>
>
> But what can we do about the specific issue?
> I am not 100% sure since as Will points out, QEMU and other
> userspace already rely on the current behaviour.
>
> Looking at QEMU specifically, it always sends some translations at
> startup, this in order to handle device rings.
>
> So, *maybe* we can get away with assuming that if no IOTLB ioctl was
> ever invoked then this userspace does not know about IOTLB and
> translation should ignore IOTLB completely.

I think this breaks the security assumptions of some setups.

>
> I am a bit nervous about breaking some *other* userspace which actually
> wants device to be blocked from accessing memory until IOTLB
> has been setup. If we get it wrong we are making guest
> and possibly even host vulnerable.

Yes.


> And of course just revering is not an option either since there
> are now whole stacks depending on the feature.
>
> Will I'd like your input on whether you feel a hack in the kernel
> is justified here.
>
> Also yes, I think it's a good idea to change crosvm anyway.  While the
> work around I describe might make sense upstream I don't think it's a
> reasonable thing to do in stable kernels.

+1

Thanks

> I think I'll prepare a patch documenting the legal vhost features
> as a 1st step even though crosvm is rust so it's not importing
> the header directly, right?
>
> --
> MST
>

