Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234B5409E35
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244098AbhIMUfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242811AbhIMUfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B458610E6;
        Mon, 13 Sep 2021 20:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631565240;
        bh=/EhioSdkkgcCZUG8sXQQ89zG+D82VpaIUWwZPLr8V6s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WJp+6TuPHyRGo/kCzwgHtcX64oAWmluZ5bRVY/uv1gmfeKRSrvU0ei7p4kzmx2dnU
         NpAPJpqT6IXe2lmHlvbxRW7LP2YX2hw3OVei52cNuvch1YbVpUbjb7Buo1Uz2Oxb1N
         xyog2+HaMgEetjfLofPp4fwbuheJbzOmk6i2gbPapPh15i4lvGmTvQs6Itjfpq0z1T
         r3R6M9xn0ftL8uzcq9ehzc+ChOwQYtyRag7S2ZCMSBTnnL2Lu1z/wqDLbqGPTmVWNP
         ul1qKPY62erf3JfhPVOhyBiZMV7NyfNYg043gaacQoUE9UUVbLkIFzEnM8OSXTvsqU
         wPfHLALc92Gvw==
Message-ID: <41bf31aec263780af85037ec3d1397aad24b7218.camel@kernel.org>
Subject: Re: [PATCH 1/2] x86: sgx_vepc: extract sgx_vepc_remove_page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Date:   Mon, 13 Sep 2021 23:33:57 +0300
In-Reply-To: <20210913131153.1202354-2-pbonzini@redhat.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
         <20210913131153.1202354-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 09:11 -0400, Paolo Bonzini wrote:
> Windows expects all pages to be in uninitialized state on startup.
> In order to implement this, we will need a ioctl that performs
> EREMOVE on all pages mapped by a /dev/sgx_vepc file descriptor:
> other possibilities, such as closing and reopening the device,
> are racy.

So what makes it racy, and what do mean by racy in this case?

I.e. you have to do open() and mmap(), and munmap() + close()
for removal. Depending on situation that is racy or not...

And is "Windows" more precisely a "Windows guest running in
Linux QEMU host"? It's ambiguous..

/Jarkko
