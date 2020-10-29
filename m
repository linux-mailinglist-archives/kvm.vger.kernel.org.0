Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A82829F36D
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgJ2Rhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:37:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbgJ2Rhj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 13:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603993058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XPgEEQsRiRhTcN1s3Q9RFlbNEdiaM1Nb8MMIVQVxnTg=;
        b=aaZXoTcy7TbO7whN1Fw661FFHXekdSSVR6Tmhv9HZOd7TwM9yDZXczcmx9VPOVZ59nsBak
        BpN63bciBFzXTfKb/LtBK2MxavygIDY5mD6M3TqYvrQHgAR1ULrBNwEX02RpLpHgAUu8U4
        /Q7lMMoEBHnvlPGdYk3mssEkVYnVPi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-bJ2990sgMAWgomy-p8ml7Q-1; Thu, 29 Oct 2020 13:37:34 -0400
X-MC-Unique: bJ2990sgMAWgomy-p8ml7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D24681882FBB;
        Thu, 29 Oct 2020 17:37:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C8255B4B5;
        Thu, 29 Oct 2020 17:37:30 +0000 (UTC)
Date:   Thu, 29 Oct 2020 18:37:27 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com, nd@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH] arm64: Add support for configuring the
 translation granule
Message-ID: <20201029173727.3mj2gel7r4ievjsn@kamzik.brq.redhat.com>
References: <20201029155229.7518-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029155229.7518-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 03:52:29PM +0000, Nikos Nikoleris wrote:
> Make the translation granule configurable for arm64. arm64 supports
> page sizes of 4K, 16K and 64K. By default, arm64 is configured with
> 64K pages. configure has been extended with a new argument:
> 
>  --page-shift=(12|14|16)
> 
> which allows the user to set the page shift and therefore the page
> size for arm64. Using the --page-shift for any other architecture
> results an error message.
> 
> To allow for smaller page sizes and 42b VA, this change adds support
> for 4-level and 3-level page tables. At compile time, we determine how
> many levels in the page tables we needed.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks for this Nikos! It looks good to me and I'll give it a test
drive soon.

drew

