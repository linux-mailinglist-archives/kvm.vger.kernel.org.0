Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2833F14BD92
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 17:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgA1QTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 11:19:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbgA1QTP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 11:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580228354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvgTVseyWvXm4+yLdxqYTDHmsvugnTvv6esW8T158zQ=;
        b=ZE7mdXLW1G+QDBarEF1gQPnL4P9ab9InSO3ILnWdrT64sZlg8BYsSJSCj0lJ+Z+mU66nY6
        T6c7Jd5uNZsKBkSmRjaIyNqhauXIKt1oB4h6pLHpF9703nC4XXQ3vOcW5e6x35rZ29sFFi
        FCfzDQAnbHIfdL02vsp21cNBS5H+2ew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-odjdjK8COimfz7FpoA3kWg-1; Tue, 28 Jan 2020 11:19:13 -0500
X-MC-Unique: odjdjK8COimfz7FpoA3kWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24464107ACC9;
        Tue, 28 Jan 2020 16:19:11 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B43B5DA7E;
        Tue, 28 Jan 2020 16:19:05 +0000 (UTC)
Date:   Tue, 28 Jan 2020 17:19:03 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, zhengxiang9@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH v22 5/9] ACPI: Record the Generic Error Status Block
 address
Message-ID: <20200128171903.7055874a@redhat.com>
In-Reply-To: <20200128154110.04baa5bc@redhat.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-6-git-send-email-gengdongjiu@huawei.com>
        <20200128154110.04baa5bc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jan 2020 15:41:10 +0100
Igor Mammedov <imammedo@redhat.com> wrote:

> On Wed, 8 Jan 2020 19:32:19 +0800
> Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> 
> in addition to comments of others:
> 
> > Record the GHEB address via fw_cfg file, when recording
> > a error to CPER, it will use this address to find out
> > Generic Error Data Entries and write the error.
> > 
> > Make the HEST GHES to a GED device.  
> 
> It's hard to parse this even kno
mine comments are not readable either, let me try again:

What I've lost at the end and wanted to say is
that even when one knows context it's hard to read commit message
and it will definitely be unreadable when one forgets context.

> Pls rephrase/make commit message more verbose,
> so it would describe why and what patch is supposed to do
[...]

