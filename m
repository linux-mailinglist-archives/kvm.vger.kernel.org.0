Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0514D1A52ED
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 18:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDKQoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Apr 2020 12:44:32 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34868 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgDKQob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Apr 2020 12:44:31 -0400
Received: by mail-ed1-f67.google.com with SMTP id c7so6207519edl.2
        for <kvm@vger.kernel.org>; Sat, 11 Apr 2020 09:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHjNiAPiJ1Oz2tFcDWgKOCe+L+oTgqAXQPJRZQ/4hzk=;
        b=fURPhmhZDafu3/qkIgLMIEfe4A4py1LqcCqCeBR+aVwJ7drlaVanUhZYjyx5KCUiZx
         KGDD6HlS++yVH8L88Y7vc/HiMTfe8JLWu5zgSXu8r7QLGa8LZ7tfbZa2cOHm/M603dUP
         wu/c+M9wGg8Em1o8TiiYeR2NppvuUZeOBDKjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHjNiAPiJ1Oz2tFcDWgKOCe+L+oTgqAXQPJRZQ/4hzk=;
        b=Rdbo+rSXxovqOrGHvR7siV0wStEjZ9pjBICrXxpAaQ++Li3iUGFzjUhzp0vwdZPPfV
         N6shP04DiST+coAUhGjYJvN8Ewhe5nfWFD685OKwg9Rh83Dqxx6FwuRAfK2G5/+Vukzb
         EXow2Zf4M63cfJOsSXXB1Dm+ny5NJEvFA78l1h/qj+rrMd9JCqybeOZ1UA+1pOsijXKe
         rsOmp3/ctiG/1V73vfu7huQgaqNf+SuZwShUrWWU5ie3tBVHshaIrvq13Ho+zob50Qux
         bs56rLDHtgqDiG2+yQU4kubhCl+1w5hH8Z+VZSNp1CA++qaMyNCoBeuU9pHGG1v0UzmK
         trgw==
X-Gm-Message-State: AGi0PuZRyWm/8qxXdMtYXdKh9t4qyOzkFpuKx1251RZp0lkRv7U36nUu
        VAyWPjv3bbDnfvNFJObpamRZPvitqlY=
X-Google-Smtp-Source: APiQypKUny/ipRJtPaRMFkHfcFwjHRErU92mDbsEu4vdMcTm2d8urxIFzu6DbmbHmu2aaSeszuNJ9w==
X-Received: by 2002:a17:907:b17:: with SMTP id h23mr8820246ejl.40.1586623468362;
        Sat, 11 Apr 2020 09:44:28 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id b5sm580920edk.72.2020.04.11.09.44.28
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Apr 2020 09:44:28 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id p6so6176417edu.10
        for <kvm@vger.kernel.org>; Sat, 11 Apr 2020 09:44:28 -0700 (PDT)
X-Received: by 2002:a2e:8652:: with SMTP id i18mr6327984ljj.265.1586623101184;
 Sat, 11 Apr 2020 09:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200406171124-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200406171124-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 11 Apr 2020 09:38:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg7sMywb2V8gifhpUDE=DWQTvg1wDieKVc0UoOSsOrynw@mail.gmail.com>
Message-ID: <CAHk-=wg7sMywb2V8gifhpUDE=DWQTvg1wDieKVc0UoOSsOrynw@mail.gmail.com>
Subject: Re: [GIT PULL] vhost: fixes, vdpa
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, eperezma@redhat.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        lingshan.zhu@intel.com, Michal Hocko <mhocko@kernel.org>,
        Nadav Amit <namit@vmware.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>, tiwei.bie@intel.com,
        tysand@google.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <wei.w.wang@intel.com>,
        xiao.w.wang@intel.com, yuri.benditovich@daynix.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 6, 2020 at 2:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> The new vdpa subsystem with two first drivers.

So this one is really annoying to configure.

First it asks for vDPA driver for virtio devices (VIRTIO_VDPA) support.

If you say 'n', it then asks *again* for VDPA drivers (VDPA_MENU).

And then when you say 'n' to *that* it asks you for Vhost driver for
vDPA-based backend (VHOST_VDPA).

This kind of crazy needs to stop.

Doing kernel configuration is not supposed to be like some truly
horrendously boring Colossal Cave Adventure game where you have to
search for a way out of maze of twisty little passages, all alike.

                Linus
