Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D762565E81
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfGKR1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 13:27:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51949 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfGKR1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 13:27:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so6467443wma.1
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yO1sVfSkD66Za17PbFJm0jKswKayheW9pPIfZ1g9g0M=;
        b=botnVKil3mdzUFgafTdlIYMcQ3YFrZsrtAa3J2e3s6kn5iFf9wcJvW3RFLUIEp2Lfp
         3RZD795FEXDXv8FB7H8OMS0Z4DxbMGKuuP6dmjw4YOe0eHBRb4O5BjDem8Y605IdPy5Y
         tnj41CJgsblA2ZBkiiE52QnAYnyO8396bI+lXwXzIV04PblqWF1RX5ZIwMRq9PLuqKJH
         vF0CvC7QfSUAmBTCEaQdxKo/RstUSuvQw/Y6j9TEVGwZvBuA3x+DGaGvAn6V2tW36Qxs
         5CkVxTotIjDmA3WVmn7rTTlOcl52sYRWqpa3ZgB9mw5MzKufCAIpOWraMsPtIvrSqWWi
         mBfw==
X-Gm-Message-State: APjAAAV+P+Dk/Jqe5LuENepxPcp9YPBLEqmQrKOpF67j7YEINte2/haI
        WSkaN6C8C1iphv1+8zMb0zptopbJpBc=
X-Google-Smtp-Source: APXvYqx8KI07GrT6NEmbPmphqRvGt4b6iNnncRRuBpdsEsmCKeO8h6PRw0o7xlHVpOeQipnTuCTgBQ==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr5334642wma.41.1562866041534;
        Thu, 11 Jul 2019 10:27:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id x83sm5924039wmb.42.2019.07.11.10.27.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 10:27:20 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 1/4] target/i386: kvm: Init nested-state for
 VMX when vCPU expose VMX
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, Joao Martins <joao.m.martins@oracle.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-2-liran.alon@oracle.com>
 <805d7eb5-e171-60bb-94c2-574180f5c44c@redhat.com>
 <901DE868-40A4-4668-8E10-D14B1E97BAE0@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <365df187-07b9-77ba-f5ef-35d0330aa914@redhat.com>
Date:   Thu, 11 Jul 2019 19:27:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <901DE868-40A4-4668-8E10-D14B1E97BAE0@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 16:36, Liran Alon wrote:
> Will you submit a new patch or should I?

I've just sent it, I was waiting for you to comment on the idea.  I
forgot to CC you though.

Paolo
