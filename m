Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9EF78D40
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfG2Nz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 09:55:56 -0400
Received: from ms.lwn.net ([45.79.88.28]:40434 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfG2Nz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 09:55:56 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 1911355A;
        Mon, 29 Jul 2019 13:55:55 +0000 (UTC)
Date:   Mon, 29 Jul 2019 07:55:54 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, rkrcmar@redhat.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: move Documentation/virtual to
 Documentation/virt
Message-ID: <20190729075554.46dfaaeb@lwn.net>
In-Reply-To: <be4ba4a7-a21b-8c56-4517-8886a754ff55@redhat.com>
References: <20190724072449.19599-1-hch@lst.de>
        <b9baabbb-9e9b-47cf-f5a8-ea42ba1ddc25@redhat.com>
        <20190724120005.31a990af@lwn.net>
        <be4ba4a7-a21b-8c56-4517-8886a754ff55@redhat.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 27 Jul 2019 00:10:32 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Does the userspace API
> cover only syscall or perhaps sysfs interfaces?   There are more API
> files (amd-memory-encryption.txt, cpuid.txt, halt-polling.txt msr.txt,
> ppc-pv.txt, s390-diag.txt) but, with the exception of
> amd-memory-encryption.txt and halt-polling.txt, they cover the
> emulated-hardware interfaces that KVM provides to virtual machines.

The user-space API certainly goes beyond system calls.  For sysfs, I
guess, the question would be whether a given knob is something that an
application would use (userspace-api) or something that a sysadmin would
want to tweak (admin-guide).

Thanks,

jon
