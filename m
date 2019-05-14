Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0DF1C36C
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 08:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfENGva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 02:51:30 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:50898 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfENGva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 02:51:30 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1hQRHc-0001A1-Lf; Tue, 14 May 2019 08:51:28 +0200
Date:   Tue, 14 May 2019 08:51:28 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux in KVM guest segfaults when hosts runs Linux 5.1
Message-ID: <20190514065128.GU3835@torres.zugschlus.de>
References: <20190512115302.GM3835@torres.zugschlus.de>
 <20190513141034.GA13337@flask>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190513141034.GA13337@flask>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 04:10:35PM +0200, Radim Krčmář wrote:
> 2019-05-12 13:53+0200, Marc Haber:
> > since updating my home desktop machine to kernel 5.1.1, KVM guests
> > started on that machine segfault after booting:
> [...]
> > Any idea short of bisecting?
> 
> It has also been spotted by Borislav and the fix [1] should land in the
> next kernel update, thanks for the report.
> 1: https://patchwork.kernel.org/patch/10936271/

I can confirm that this patch fixes the segfaults for me.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
