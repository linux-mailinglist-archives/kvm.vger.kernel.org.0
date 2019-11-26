Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7695D10A587
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 21:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKZUfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 15:35:34 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40173 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfKZUfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 15:35:34 -0500
Received: by mail-lj1-f196.google.com with SMTP id s22so2784612ljs.7
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2019 12:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=K4Bc+8eHqvfcdZUohVg+/Nb9ohh1S05Ow4H5opvoqhk=;
        b=hP8MBek+jIyGLD+HG0jW2xvdPV0teuBv/6k2y1ZOfuFlO/HjwikQPbJcxccaCkY4ca
         gjaTQdQJuJuuDe7KXGd7CHEz647Qh6NX9XAIW3c4Z8FK6pZpjhGsPKjwmxaJVD5IlM/X
         Z5/WxylRjt2WqI7WJW+aZcE6o+zYKjTFcMG7c0n8bOuwNbF7ICmk+Fxg7pHQ7dwDF31l
         NmFxlfLTZZuYjXH9EvJKULzXQ8K11aH69Hhg25nRJk/+Jd3ZLFE+87+CG7Iv/YLiH0r1
         8nEtemUANXF+RxlU+k7p/LnGQqcmKLtW90x47b0ZBqnVjm14VykY0TyefIzMoDaXqk0J
         rZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=K4Bc+8eHqvfcdZUohVg+/Nb9ohh1S05Ow4H5opvoqhk=;
        b=WRQDPAkeEe6YCChtYqbwPogkeEaGEThtwUMVawc/NSH+bozSO6SnduXv6rg0dv8sdf
         Irt20r/OAR0Z1qtEe65fnBZaKF3w8tVvpbpcnSpO4v+vhGy8+sJlcwLHTausVgkMi1G+
         Er/mlo1Tufz2bIqdolbDxMpAORHEQZRQAxZTapuB0h5jSCQWPBXJInCEXz6q9znnrbQW
         52SO+KncdZmYyh6RpTpLRMVD9rCCRZ3q1fRpS2SHuw8QXyNUiUdUyrK/f3l9w/RRVery
         qk8tj6ysyTFsqpsjERUgBrIksMrD/GA+EAeAO11872xjC6UROrjLYlUdImEWr9Zweqog
         68aQ==
X-Gm-Message-State: APjAAAV51UCzjZFZrruYmSkZpP+tGvIRfVi16yPqhTJ+EHZOGLk+YjiP
        DLA3RMShnkj5nhmm2WOaIY7tVYfNl1k=
X-Google-Smtp-Source: APXvYqx9IqBt3lkqgKwa8lRqh+EMXV4Z5INEt5vZARRFzhNGU5/ykWOAvkTYwnAGobZix7373gRwCQ==
X-Received: by 2002:a2e:8885:: with SMTP id k5mr11915374lji.98.1574800532208;
        Tue, 26 Nov 2019 12:35:32 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z127sm5839668lfa.19.2019.11.26.12.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:35:31 -0800 (PST)
Date:   Tue, 26 Nov 2019 12:35:14 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
Message-ID: <20191126123514.3bdf6d6f@cakuba.netronome.com>
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Nov 2019 19:07:26 +0900, Prashant Bhole wrote:
> Note: This RFC has been sent to netdev as well as qemu-devel lists
> 
> This series introduces XDP offloading from virtio_net. It is based on
> the following work by Jason Wang:
> https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
> 
> Current XDP performance in virtio-net is far from what we can achieve
> on host. Several major factors cause the difference:
> - Cost of virtualization
> - Cost of virtio (populating virtqueue and context switching)
> - Cost of vhost, it needs more optimization
> - Cost of data copy
> Because of above reasons there is a need of offloading XDP program to
> host. This set is an attempt to implement XDP offload from the guest.

This turns the guest kernel into a uAPI proxy.

BPF uAPI calls related to the "offloaded" BPF objects are forwarded 
to the hypervisor, they pop up in QEMU which makes the requested call
to the hypervisor kernel. Today it's the Linux kernel tomorrow it may 
be someone's proprietary "SmartNIC" implementation.

Why can't those calls be forwarded at the higher layer? Why do they
have to go through the guest kernel?

If kernel performs no significant work (or "adds value", pardon the
expression), and problem can easily be solved otherwise we shouldn't 
do the work of maintaining the mechanism.

The approach of kernel generating actual machine code which is then
loaded into a sandbox on the hypervisor/SmartNIC is another story.

I'd appreciate if others could chime in.
