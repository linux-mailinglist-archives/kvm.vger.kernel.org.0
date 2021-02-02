Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B273B30BDA1
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 13:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBBMFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 07:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhBBMFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 07:05:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12CDA64F53;
        Tue,  2 Feb 2021 12:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612267466;
        bh=vpa76DJVw3u2hImBgcGY2RefNVrkqI+c8q81hUCChG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IgUfc5NoKYN48z3xn3H9Z2AYFDRkw6a/uH5nFMZS5cIBCXMCVRf6GQGuNGkyMaH4G
         Fcfl8CYT2GXLLKm/8Tgov0ejWOyQPSvbiZq2uL6aaBcU1Eh2lOQOPnow+TsTFU4tuA
         tDZoAwHYvXTfc2sFlK2NPw4+AgpSPcWPEQtblr24=
Date:   Tue, 2 Feb 2021 13:04:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Catangiu <acatan@amazon.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, graf@amazon.com, rdunlap@infradead.org,
        arnd@arndb.de, ebiederm@xmission.com, rppt@kernel.org,
        0x7f454c46@gmail.com, borntraeger@de.ibm.com, Jason@zx2c4.com,
        jannh@google.com, w@1wt.eu, colmmacc@amazon.com, luto@kernel.org,
        tytso@mit.edu, ebiggers@kernel.org, dwmw@amazon.co.uk,
        bonzini@gnu.org, sblbir@amazon.com, raduweis@amazon.com,
        corbet@lwn.net, mst@redhat.com, mhocko@kernel.org,
        rafael@kernel.org, pavel@ucw.cz, mpe@ellerman.id.au,
        areber@redhat.com, ovzxemul@gmail.com, avagin@gmail.com,
        ptikhomirov@virtuozzo.com, gil@azul.com, asmehra@redhat.com,
        dgunigun@redhat.com, vijaysun@ca.ibm.com, oridgar@gmail.com,
        ghammer@redhat.com
Subject: Re: [PATCH v5 1/2] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <YBk/xskdrwqTOyM9@kroah.com>
References: <1612200294-17561-1-git-send-email-acatan@amazon.com>
 <1612200294-17561-2-git-send-email-acatan@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612200294-17561-2-git-send-email-acatan@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 07:24:53PM +0200, Adrian Catangiu wrote:
> +config SYSGENID
> +	tristate "System Generation ID driver"
> +	default N

"N" is always the default, no need to list it again :(

