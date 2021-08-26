Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA353F854B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbhHZK2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:28:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233966AbhHZK2j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629973671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UqwcFB3NH3TUfjydBburEvpc2bl5R15xjZ+9ZsXFipg=;
        b=bonBtKX851THijJoJvCHJJyEzI03wpN1a/Lcy3cdHEK563w5zBP7t1KYEIfqGuoBNB9hq7
        b0ucb0p0pNlMm8oygICCfgCjuMBgaw3zl2ZShtUEAukCsuO5FUF7RUktBnMNS2E38gZjWK
        c9WxMj+7hOnc8kFnmQ6j3w+45jBVbbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-gFX7_2fpNk6WKXISYqTPmQ-1; Thu, 26 Aug 2021 06:27:20 -0400
X-MC-Unique: gFX7_2fpNk6WKXISYqTPmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 134EFC2A7;
        Thu, 26 Aug 2021 10:27:19 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0584E19C59;
        Thu, 26 Aug 2021 10:27:15 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 5FC5F18003AA; Thu, 26 Aug 2021 12:27:13 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:27:13 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 10/44] hw/i386: Initialize TDX via KVM ioctl()
 when kvm_type is TDX
Message-ID: <20210826102713.sv4744gt6zersind@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <d173ac1f4524153b738309530c6a6599aeaa18fd.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d173ac1f4524153b738309530c6a6599aeaa18fd.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

>        'sev-guest':                  'SevGuestProperties',
> +      'tdx-guest':                  'TdxGuestProperties',

Ah, see, it's already there ...

take care,
  Gerd

