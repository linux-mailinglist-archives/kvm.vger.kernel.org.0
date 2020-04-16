Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A881AC231
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 15:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895100AbgDPNTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 09:19:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2895029AbgDPNT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 09:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587043166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JEw6kLXze2haywQeiOQ5EDcQGVtvnQE9Y5SKoxEqeF4=;
        b=htTvGhIM6gnjZXJYO8p6yoXvPNe9svqQvDuyce4Q9GKjoIrXcqIJpV1TnbciKJyRvKfRrQ
        KEXO7WzH0bvdSKYG7qS5vQ6itq6vPDFZFgnDH3fonzVIH2aDk8aJ1oDyC+2tg9CU9FlezJ
        +iKnmwWASdA5HmUjI8fGiiq0uLDzbuE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-NrQYZCJFNpuUn14sd5Zi9w-1; Thu, 16 Apr 2020 09:19:24 -0400
X-MC-Unique: NrQYZCJFNpuUn14sd5Zi9w-1
Received: by mail-wr1-f70.google.com with SMTP id 11so1712737wrc.3
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JEw6kLXze2haywQeiOQ5EDcQGVtvnQE9Y5SKoxEqeF4=;
        b=Wqb6+wEW37Zw8fC1Kty+zbINBr74UJSjFRzlj2ATGWZRibe8unxIhpFEp06Y5+3371
         tUtm5hpN4NDyiNWShoDJczysx+CnTfZD3Lq2XSCcDa+Q5j1Sh52UrQX6lg5+N8hOzVyU
         F60TFdUuFg//zsxoRtM/CgbV5QE7e3R7uM936543sAgbMAG5vIHy/PRjI27EbPChFP+r
         tmrHptYS9ghjyhSOqIhXS8NeIE+7gf2iNPxh8rJHejetK/Ra+1BvWmzW/gCKiypwcTlp
         jGGteMq3fO5URQAgary7vg4evk/hOYcSwG33cgnKbE2IIiE2d16I/7s3tfNy7gx/VVNn
         mV0g==
X-Gm-Message-State: AGi0PubKRsd3SKMXYKfUT0RKqERL4dBk4WB9H6RZ9zPIU1Pkl/dTDlns
        Jhcw7wLfw745YhCmOO1zU2yjbhaOupV91NQjnIr5PuW+KcU4dR0RS3NAcRsZflsJGWCT9STAYsT
        s4yUM1IHj8S2A
X-Received: by 2002:a5d:6841:: with SMTP id o1mr34561676wrw.412.1587043163235;
        Thu, 16 Apr 2020 06:19:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypKQ4lbeOSyR1XshDuR8EWNRydxPgHwd1xV9n6dwTTctMb3egplsxM/9j9R5WhC8asCM1+2Ung==
X-Received: by 2002:a5d:6841:: with SMTP id o1mr34561653wrw.412.1587043163015;
        Thu, 16 Apr 2020 06:19:23 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 74sm15403795wrk.30.2020.04.16.06.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 06:19:22 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v10 7/7] KVM: selftests: update hyperv_cpuid with SynDBG tests
In-Reply-To: <20200416110540.GK7606@jondnuc>
References: <20200324074341.1770081-1-arilou@gmail.com> <20200324074341.1770081-8-arilou@gmail.com> <87d09286mx.fsf@vitty.brq.redhat.com> <20200416110540.GK7606@jondnuc>
Date:   Thu, 16 Apr 2020 15:19:21 +0200
Message-ID: <87v9lzva92.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> Did this patchset make it into the merge window?
>

My crystal ball tells me we should ask Paolo (To:) ;-)

-- 
Vitaly

