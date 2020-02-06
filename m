Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34A11548AD
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgBFP5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:57:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbgBFP5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581004669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M64chN0/OX0a1UohSwKHiZmjrUwcsKemKwqHXfLEkjg=;
        b=WPLPVAKstpumPeazkrQfFGcj89yNYY8gPOJE1XMX8b/+7MBtGVX/6ydu/jo3VQf/hnk1Q+
        RN1xn5TKU7/FWCN+YCT54/sM6SX+3SFDKsdSQx/vCoth7GQXEBNHhYhsXbvI361ot3T8yZ
        F0JoCk73xaAqRxRdinZN73jUsJgos80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-QDGNm_00P1eT3hpTjRAqwA-1; Thu, 06 Feb 2020 10:57:46 -0500
X-MC-Unique: QDGNm_00P1eT3hpTjRAqwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49394101FC65;
        Thu,  6 Feb 2020 15:57:42 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11334100164D;
        Thu,  6 Feb 2020 15:57:40 +0000 (UTC)
Date:   Thu, 6 Feb 2020 16:57:38 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 14/27] docs: kvm: convert devices/vm.txt to ReST
Message-ID: <20200206165738.6bd1471e.cohuck@redhat.com>
In-Reply-To: <e6479611547db305852ac609a26b851c6ba7ff02.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <e6479611547db305852ac609a26b851c6ba7ff02.1581000481.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 15:50:11 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> - Use title markups;
> - adjust indentation and add blank lines as needed;
> - use :field: markups;
> - Use cross-references;
> - mark code blocks as such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/devices/index.rst      |   1 +
>  .../virt/kvm/devices/{vm.txt => vm.rst}       | 206 +++++++++++-------
>  2 files changed, 127 insertions(+), 80 deletions(-)
>  rename Documentation/virt/kvm/devices/{vm.txt => vm.rst} (61%)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

