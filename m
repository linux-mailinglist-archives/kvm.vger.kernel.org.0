Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8B36249F3
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfEUIOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 04:14:33 -0400
Received: from smtp.lucina.net ([62.176.169.44]:59568 "EHLO smtp.lucina.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfEUIOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 04:14:33 -0400
Received: from nodbug.lucina.net (188-167-250-119.dynamic.chello.sk [188.167.250.119])
        by smtp.lucina.net (Postfix) with ESMTPSA id 62474122804
        for <kvm@vger.kernel.org>; Tue, 21 May 2019 10:14:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lucina.net;
        s=dkim-201811; t=1558426471;
        bh=RzBh0FTeZzm3L7Y0gioKJyuRnmwR3NDrJ3Kv0yYjS18=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=BkA61JjTXUItefs411TWA3s3GOFlwnQH5jXMRI8hjn2Y4eVjUJEV/axHrf38J1CC6
         l+KNOs2yHTlMWa0z/z6ejkE9y5cIPKEysanNo7UHOK/4E5Q/Mqdpcka1zq6WL0Qu4Z
         HwhWHcvSZDRldGc5+Ykc/6vpzGe9LgCU1aQ/vjGLs3lKEQ84hSsZc5ZzP2g6riQbpd
         VoAbEFWRXr9aE/hKY5HRA2XRigf+kP7as0jldvGoV5+O4saG3LIz5Qrgklpj9+wYlE
         IfiiMBVG2INIrIbVa2AR3Qod29+1LZti6i4C0cFAaRKSNbmE6n71njBRBIuevWry8z
         /IwHerYuLVhuw==
Received: by nodbug.lucina.net (Postfix, from userid 1000)
        id 1E7C6268437A; Tue, 21 May 2019 10:14:31 +0200 (CEST)
Date:   Tue, 21 May 2019 10:14:31 +0200
From:   Martin Lucina <martin@lucina.net>
To:     kvm@vger.kernel.org
Subject: Re: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190521081431.yexwxcx2z536n5lg@nodbug.lucina.net>
References: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 21.05.2019 at 09:24, Martin Lucina wrote:
> Questions:
> 
> a. Is this the intended behaviour, and can it be relied on? Note that
> KVM/aarch64 behaves the same for me.

As a further data point, I've added a check in the userspace tender binary to
verify that sys_personality does not include READ_IMPLIES_EXEC, though it
appears that my toolchain (Debian stable) is producing binaries with -z
noexecstack by default.

Martin
