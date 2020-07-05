Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33220214F77
	for <lists+kvm@lfdr.de>; Sun,  5 Jul 2020 22:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgGEUmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Jul 2020 16:42:33 -0400
Received: from ms.lwn.net ([45.79.88.28]:51774 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbgGEUmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Jul 2020 16:42:32 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 85AA5739;
        Sun,  5 Jul 2020 20:42:32 +0000 (UTC)
Date:   Sun, 5 Jul 2020 14:42:31 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] Documentation: virt: eliminate duplicated words
Message-ID: <20200705144231.6202b4de@lwn.net>
In-Reply-To: <20200703212906.30655-1-rdunlap@infradead.org>
References: <20200703212906.30655-1-rdunlap@infradead.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Jul 2020 14:29:04 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> Drop doubled words in Documentation/virt/kvm/.
> 
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> 
> 
>  Documentation/virt/kvm/api.rst     |   16 ++++++++--------
>  Documentation/virt/kvm/s390-pv.rst |    2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
Applied, thanks.

jon
