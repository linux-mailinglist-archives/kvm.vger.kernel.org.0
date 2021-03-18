Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2E3402B4
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCRKFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 06:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhCRKFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 06:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BF0164F3B;
        Thu, 18 Mar 2021 10:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616061905;
        bh=4d5oH7IMHxQWeN3GZ6nwg+kRWh8KUCctrYbE4IcMyv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXz9Zpzs7Ya7MVm7RvUq9aeD7fyI9S/Aha0yfUj3OFuLpyBZUfPSgHVrD/BBMZ2DJ
         VuNoKZk2CvIvXWZboaPTCwueeHNuUdm7+wHXoG6tsQTpD0CEP9rXIneP6rdLzaOBiU
         jWKekc+9qyA6GSCeFYmr8U0jrm1SrLfMiHIh/64Q70VV0tnvKi/RY5mWESwxpte9/z
         k1cohhhYGBp209qGWt2xjgpqX+Ptv7Ea4uLjlZj13989IXudnbJ6PWaZy4VIxJmacd
         ozxfZ2KpghsKWDN+v1awBW8vb6fLTmTbUYckcFmSLlJ+0NhReq0LaFhVh9iLMEf6Y9
         M28iDpIo121mA==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, "G . Campana" <gcampana+kvm@quarkslab.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool] virtio: add support for vsock
Date:   Thu, 18 Mar 2021 10:04:56 +0000
Message-Id: <161606117736.553622.15465802475593331496.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200915094402.107988-1-tianjia.zhang@linux.alibaba.com>
References: <20200915094402.107988-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 17:44:02 +0800, Tianjia Zhang wrote:
> The "run" command accepts a new option (--vsock <cid>) which specify the
> guest CID. For instance:
> 
>   $ lkvm run --kernel ./bzImage --disk test --vsock 3
> 
> One can easily test by: https://github.com/stefanha/nc-vsock.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio: add support for vsock
      https://git.kernel.org/will/kvmtool/c/117d64953228

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
