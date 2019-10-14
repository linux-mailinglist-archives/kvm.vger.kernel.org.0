Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5C3D64CA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbfJNOKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 10:10:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38796 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732349AbfJNOKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 10:10:18 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iK139-0001Ft-NS; Mon, 14 Oct 2019 16:10:15 +0200
Date:   Mon, 14 Oct 2019 16:10:15 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
cc:     kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org, platform-driver-x86@vger.kernel.org,
        x86@kernel.org, iommu@lists.linux-foundation.org,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        gavin.guo@canonical.com, halves@canonical.com,
        ioanna-maria.alifieraki@canonical.com, jay.vosburgh@canonical.com,
        mfo@canonical.com
Subject: Re: Advice on oops - memory trap on non-memory access instruction
 (invalid CR2?)
In-Reply-To: <66eeae28-bfd3-c7a0-011c-801981b74243@canonical.com>
Message-ID: <alpine.DEB.2.21.1910141602270.2531@nanos.tec.linutronix.de>
References: <66eeae28-bfd3-c7a0-011c-801981b74243@canonical.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Oct 2019, Guilherme G. Piccoli wrote:
> Modules linked in: <...>
> CPU: 40 PID: 78274 Comm: qemu-system-x86 Tainted: P W  OE

Tainted: P     - Proprietary module loaded ...

Try again without that module

Tainted: W     - Warning issued before

Are you sure that that warning is harmless and unrelated?

> 4.4.0-45-generic #66~14.04.1-Ubuntu

Does the same problem happen with a not so dead kernel? CR2 handling got
quite some updates/fixes since then.

Thanks,

	tglx


