Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0AD190C6C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCXL24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:28:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35634 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbgCXL24 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 07:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585049335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktuTLWFbdGaqqJxefhDZte1DvZgH9my8ZHHD853RboI=;
        b=h2/eaB9dO98C0D0wrrv1zFAX4DQL8a0VXweX4Ld9Kf4IAg1/F4omhbbhxf3FE+wZeSbEBz
        DCfl0SYW9WF7S3AAtRW78kvyNxXE4Q4387/vASSIvSmnrnapG46k2Ac0Zola+f8fUuUT0W
        OK0QiMycqxLjFwDHSuTYcOWRpL8s2HI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-lVN6EpesM-iQG-eO_U3x5Q-1; Tue, 24 Mar 2020 07:28:51 -0400
X-MC-Unique: lVN6EpesM-iQG-eO_U3x5Q-1
Received: by mail-wr1-f70.google.com with SMTP id b11so9054528wru.21
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ktuTLWFbdGaqqJxefhDZte1DvZgH9my8ZHHD853RboI=;
        b=olQrXF1U82DYOd0u+47oeM3U2xHKJqnCerHfwGU+qqMHQwNF91WszMpOeHjGKApppr
         SaiQzQBdD8SLAQtE+NPPefgrmQ2ettjcCKj47K1xeExZpvIiQGSsfKYYy+RM+BN+vB34
         oleUkVF5VcUSTs8JnT5q1FPbU33wbIRLB2ufrOeUpKFlHLZkYi1IpuDNpaoYWjaWK3Y3
         A11ENyUjkt64bmnJzeVnKMo/SH4Jy0axVlOEa35H03o64PwyBfJ/0fiREUF8SVXzRzqY
         RQ4DFJa7jsakxMwbmFvmoQYnfqtkV+iGVaEQ6Me6lOsKcOeDrWdowis+P8ikQd581z/i
         m+dg==
X-Gm-Message-State: ANhLgQ1zgo6jazh/i8fmFSEaEom9NaSdGmj7m0LIZe+5esS8TU1SFVf1
        YWXCLI4zXijzI7p33O9Dvh1+8HApsdnwbrqjhtIL5r6Bc+znIQKYyCNorpfZ+LB4+Z6385H13z/
        i56neLVH+Ig8l
X-Received: by 2002:a05:600c:295e:: with SMTP id n30mr4362452wmd.78.1585049330627;
        Tue, 24 Mar 2020 04:28:50 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vu8wwBP/1By0+yDJsZyGCHmSqEqyjVhDJVEFj/LdirTJpqlyAsnxBXSoDiLlerfPdX0RN46HA==
X-Received: by 2002:a05:600c:295e:: with SMTP id n30mr4362433wmd.78.1585049330385;
        Tue, 24 Mar 2020 04:28:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7848:99b4:482a:e888? ([2001:b07:6468:f312:7848:99b4:482a:e888])
        by smtp.gmail.com with ESMTPSA id i4sm29188405wrm.32.2020.03.24.04.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 04:28:49 -0700 (PDT)
Subject: Re: [PATCH 4/7] KVM: selftests: Add helpers to consolidate open coded
 list operations
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-5-sean.j.christopherson@intel.com>
 <20200320224744.GG127076@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <23f62756-aca2-12d0-c2cc-baafafd76280@redhat.com>
Date:   Tue, 24 Mar 2020 12:28:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200320224744.GG127076@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 23:47, Peter Xu wrote:
> I'm not sure whether we should start to use a common list, e.g.,
> tools/include/linux/list.h, if we're going to rework them after all...
> Even if this is preferred, maybe move to a header so kvm selftests can
> use it in the future outside "vcpu" struct too and this file only?

Yes, we should.

Paolo

