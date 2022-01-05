Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A53484F70
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 09:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiAEIiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 03:38:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232301AbiAEIiv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 03:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641371930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mEb/gZeH1D1Bp968fhLbAmJxq5KAIuLJnF/KYymcJMU=;
        b=LoQ/ZcQRhVC/bcQv3sXQOQryrX81Y4jImFrCn5EdEgEKfeTHSdUG8xksP9wDHFk0dg63Et
        Mv1R5d7YKjZzRwDiJQodvN39jj2P1cbv1o2WocDWcZi4Zpu8r9k4teOMRn0pYIEj3Gj18v
        q2e1/kJyjjo2JQsHypPdbcBy4Vs0xn0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-ZXj1Z3zoP32G1C08GcYCXQ-1; Wed, 05 Jan 2022 03:38:50 -0500
X-MC-Unique: ZXj1Z3zoP32G1C08GcYCXQ-1
Received: by mail-pf1-f199.google.com with SMTP id n4-20020aa79044000000b004bcd447b6easo1817297pfo.22
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 00:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mEb/gZeH1D1Bp968fhLbAmJxq5KAIuLJnF/KYymcJMU=;
        b=wgcpnY8oupeyYsULxZ8FU4l2U2Sq0Ws1Y+J/4rUedgQ4ui5dFG4j9VQ+fE0o6IKfWS
         mnW1fxIB1lqkfHDvVJsQR0zTeA5IkAoXDyOdU1WnVdnjZok1ntuoT9ibYlvuk3OdNqSp
         AX28Dtd6kmf6XZog+3Wef0nXuO1pYe0VPQv9tpntQAttgWflbiUX5/LTjR8tnnvOioiY
         pmpUW4tGWempMSxLKduiQbQCpWzg+4ryTzqmF94Le84QI3n/SiXfbf/5IetLol6PYcJR
         wYzxZz2FOelYVg3iLKTwbxFCuQws7D3bIyd0QDeDk9HLA/pgQSqcAJv3J939Y1d1LP5a
         JSpw==
X-Gm-Message-State: AOAM531e92nZn3se8QwjoRne+b1Dhq1ryg0H+FpDh6kdmxzxtMVciHWL
        me++VHhDMseOOKDcTFtqTYgDPIEFSDizGNkReC0YYAnchiNAeX8oHvDTjslU8DrdTyUhorilmzZ
        X45IVNS2sdat+
X-Received: by 2002:a17:902:8488:b0:149:8545:5172 with SMTP id c8-20020a170902848800b0014985455172mr38831456plo.132.1641371928842;
        Wed, 05 Jan 2022 00:38:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzC0kkplYRgS6zHXxINO8XYEaHfoqGBUa6qEu2Ph/0WsiS9vIzrTqnZ7yGgrLh07SL4JQQh+w==
X-Received: by 2002:a17:902:8488:b0:149:8545:5172 with SMTP id c8-20020a170902848800b0014985455172mr38831434plo.132.1641371928581;
        Wed, 05 Jan 2022 00:38:48 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id z18sm47443638pfe.146.2022.01.05.00.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 00:38:48 -0800 (PST)
Date:   Wed, 5 Jan 2022 16:38:40 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 12/13] KVM: x86/mmu: Add tracepoint for splitting huge
 pages
Message-ID: <YdVZEFzgft/dQQ/x@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-13-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-13-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021 at 10:59:17PM +0000, David Matlack wrote:
> Add a tracepoint that records whenever KVM eagerly splits a huge page.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

