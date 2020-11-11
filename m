Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990A52AF469
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 16:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgKKPHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 10:07:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgKKPHF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 10:07:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605107224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PGhEId3sEQsKzhjxjbqIPpibBj9VkrJZw+En0ATcFIE=;
        b=WaFJtkWPqRRZAIknDn6xNzCmeE4NHosezhSteqJHLuFsO1+zeyKnAJg2Wv5R7MiQ5NdlSw
        EZeB9fHJztCUAJffQrE/XJ3KWfL2IO94LNWOryi9VRL8Qz0jDj7NRvLqAQMiz22aAFjqsA
        fvPMSSGz8o4ZyUGCebCrW8eEL+KEcwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-lbBwcBu4MCGi2iB1HA-HtA-1; Wed, 11 Nov 2020 10:07:02 -0500
X-MC-Unique: lbBwcBu4MCGi2iB1HA-HtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBDBC1074659
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 15:07:01 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E085027BAE;
        Wed, 11 Nov 2020 15:07:00 +0000 (UTC)
Date:   Wed, 11 Nov 2020 16:06:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests 3/3] arm/arm64: Change dcache_line_size to
 ulong
Message-ID: <20201111150657.iba62fbbkfj4prxa@kamzik.brq.redhat.com>
References: <20201014191444.136782-1-drjones@redhat.com>
 <20201014191444.136782-4-drjones@redhat.com>
 <f4d0035a-717b-042c-1469-0fdd3843cce7@redhat.com>
 <939c571b-d717-878f-9193-5e6361192dac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <939c571b-d717-878f-9193-5e6361192dac@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 31, 2020 at 03:32:45PM +0100, Paolo Bonzini wrote:
> 
> Queued all three, thanks.
>

Hi Paolo,

Can you please push these?

Thanks,
drew

