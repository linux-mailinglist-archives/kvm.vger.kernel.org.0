Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB7C1A17C9
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgDGWJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 18:09:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51950 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDGWJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 18:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VJbgJAe6SzFkTbL5NsrOiwu1YrOSYf9AuTvbCQyh2as=; b=iCObDzZc2zb180nZviio0/UZ4M
        XbD2xLkOJKVKFtTzRB3pQtU1xuFg/mRiketYbkyo95gNuUZu/RYpMLGMLEtNjHEFf7IUJiQjLva9c
        V/6o4/8pp8afW0q+98Mhf3vK/KJizovWUEE6NotVQG8QCQGNKuhMUZ45DKyoYSldfD7oC2X5h7/JN
        CcmVAAc5VuOI5b6glfDC6QslCfsjxmkUvhTZuNtXXJTL+qcGOdPgkiJaUwOLm8srO7XhUGKeHVoGQ
        o39NivE5EyBKfTdB71zGmQ+TxBYN2hahpWqCc2+9EelwrMbdoyfaQuFR6rMMvbPHE08JvTkYr4wX4
        sFty8Y8g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLwOx-0002CD-HJ; Tue, 07 Apr 2020 22:08:59 +0000
Date:   Tue, 7 Apr 2020 15:08:59 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+516667c144d77aa5ba3c@syzkaller.appspotmail.com>
Cc:     alex.shi@linux.alibaba.com, armijn@tjaldur.nl,
        gregkh@linuxfoundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rfontana@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: KASAN: slab-out-of-bounds Read in __kvm_map_gfn
Message-ID: <20200407220859.GL21484@bombadil.infradead.org>
References: <00000000000001be5205a2b90e71@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000001be5205a2b90e71@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 01:16:11PM -0700, syzbot wrote:
> The bug was bisected to:
> 
> commit 3a00e7c47c382b30524e78b36ab047c16b8fcfef
> Author: Alex Shi <alex.shi@linux.alibaba.com>
> Date:   Tue Jan 21 08:34:05 2020 +0000
> 
>     ida: remove abandoned macros

Definitely a bad bisect.
