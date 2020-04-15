Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371F41A936C
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 08:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634919AbgDOGnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 02:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393583AbgDOGnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 02:43:22 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59798C061A0C;
        Tue, 14 Apr 2020 23:43:22 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a43so3257426edf.6;
        Tue, 14 Apr 2020 23:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KS5I1xey5qWdWCCxHOW9gisVgPOdfTeYMV2x/9+Flfo=;
        b=sN8HRF3ni60qScLQ9lgBgPcjgKEQZKT2fjDSm8aJfJdr+SFMRPjaid7ryokZOT2IFK
         Qs4HdYjSoQc9EVuFOfqOgibHurpls5jIAfKatHH3z/u5sOwYNexiAqfCBGklOQEFhiH5
         3123YGWrI+BCKP9KdzKodHL3UhT/3G2sI65K5LQV4+0Eaj4UIJEkbt8p3GlAFkqqECAp
         MM9pBT+etucFvdgZrmIHiAvkWg8pfTPIsrZXYhgz0GqDWjWYAe1W2Jg4hQrZxnGR7J7I
         DXKpR35gVGby2BlRAqWjElUFFHt8h/+38Vn7ClyRw3dhSqIqYmgtQ86wI+2gtP97/f2u
         6+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KS5I1xey5qWdWCCxHOW9gisVgPOdfTeYMV2x/9+Flfo=;
        b=ADuMkPXQYbVNcibi5njvAI3pJc6xj8GvJPM3TniJJdr9Fzp4D+ihpmXkB6JJ4Eoj16
         /1uRoIJfPMl2OpDK838+Fof5tx4uy9toH8llgzi3HZ5bYSV7N5tm8s6g4KYQtgubBJ7C
         niPbrbnaqit4kcMvWLLSbPGvpdXWljtioNEzSqKMwENIto9TrKCNaNn66YqznpMNufXx
         sVzZK+OPGvyOdzU1ytVOGSN4dXe8HrcpTBh/7xc/rsTqjEHGe1qgr8qabRjhjuFUKS+5
         pYrWlhqJMelMfLYOrM0dOrtA12XYc8xsoyo9KVb9LbgfZVFiHwFyYPr7H9hiqCBz87Iw
         tboA==
X-Gm-Message-State: AGi0PubOUKSkxv/5D+AgRTezkuAN/B2behnSisJuJbjGcbF5l7PC4Ulj
        raEATwAh6ruY1acbWGxdHgc=
X-Google-Smtp-Source: APiQypLoBpg3FM2Ci5vp77S7a/Ww05Hwpd/ejUHk1DghI5OsILOLJoHG7cpRnKlxWnMFatnnEsZE0Q==
X-Received: by 2002:a17:906:3085:: with SMTP id 5mr3595386ejv.381.1586933001111;
        Tue, 14 Apr 2020 23:43:21 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net. [83.42.57.116])
        by smtp.gmail.com with ESMTPSA id z13sm2032486edj.0.2020.04.14.23.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 23:43:20 -0700 (PDT)
Subject: Re: [PATCH] mips: define pud_index() regardless of page table folding
To:     Mike Rapoport <rppt@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        maobibo <maobibo@loongson.cn>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>
References: <20200402081614.5696-1-rppt@kernel.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Autocrypt: addr=f4bug@amsat.org; keydata=
 mQINBDU8rLoBEADb5b5dyglKgWF9uDbIjFXU4gDtcwiga9wJ/wX6xdhBqU8tlQ4BroH7AeRl
 u4zXP0QnBDAG7EetxlQzcfYbPmxFISWjckDBFvDbFsojrZmwF2/LkFSzlvKiN5KLghzzJhLO
 HhjGlF8deEZz/d/G8qzO9mIw8GIBS8uuWh6SIcG/qq7+y+2+aifaj92EdwU79apZepT/U3vN
 YrfcAuo1Ycy7/u0hJ7rlaFUn2Fu5KIgV2O++hHYtCCQfdPBg/+ujTL+U+sCDawCyq+9M5+LJ
 ojCzP9rViLZDd/gS6jX8T48hhidtbtsFRj/e9QpdZgDZfowRMVsRx+TB9yzjFdMO0YaYybXp
 dg/wCUepX5xmDBrle6cZ8VEe00+UQCAU1TY5Hs7QFfBbjgR3k9pgJzVXNUKcJ9DYQP0OBH9P
 ZbZvM0Ut2Bk6bLBO5iCVDOco0alrPkX7iJul2QWBy3Iy9j02GnA5jZ1Xtjr9kpCqQT+sRXso
 Vpm5TPGWaWljIeLWy/qL8drX1eyJzwTB3A36Ck4r3YmjMjfmvltSZB1uAdo1elHTlFEULpU/
 HiwvvqXQ9koB15U154VCuguvx/Qnboz8GFb9Uw8VyawzVxYVNME7xw7CQF8FYxzj6eI7rBf2
 Dj/II6wxWPgDEy3oUzuNOxTB7sT3b/Ym76yOJzWX5BylXQIJ5wARAQABtDFQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoRjRCVUcpIDxmNGJ1Z0BhbXNhdC5vcmc+iQJVBBMBCAA/AhsPBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBPqr514SkXIh3P1rsuPjLCzercDeBQJd660aBQks
 klzgAAoJEOPjLCzercDe2iMP+gMG2dUf+qHz2uG8nTBGMjgK0aEJrKVPodFA+iedQ5Kp3BMo
 jrTg3/DG1HMYdcvQu/NFLYwamUfUasyor1k+3dB23hY09O4xOsYJBWdilkBGsJTKErUmkUO2
 3J/kawosvYtJJSHUpw3N6mwz/iWnjkT8BPp7fFXSujV63aZWZINueTbK7Y8skFHI0zpype9s
 loU8xc4JBrieGccy3n4E/kogGrTG5jcMTNHZ106DsQkhFnjhWETp6g9xOKrzZQbETeRBOe4P
 sRsY9YSG2Sj+ZqmZePvO8LyzGRjYU7T6Z80S1xV0lH6KTMvq7vvz5rd92f3pL4YrXq+e//HZ
 JsiLen8LH/FRhTsWRgBtNYkOsd5F9NvfJtSM0qbX32cSXMAStDVnS4U+H2vCVCWnfNug2TdY
 7v4NtdpaCi4CBBa3ZtqYVOU05IoLnlx0miKTBMqmI05kpgX98pi2QUPJBYi/+yNu3fjjcuS9
 K5WmpNFTNi6yiBbNjJA5E2qUKbIT/RwQFQvhrxBUcRCuK4x/5uOZrysjFvhtR8YGm08h+8vS
 n0JCnJD5aBhiVdkohEFAz7e5YNrAg6kOA5IVRHB44lTBOatLqz7ntwdGD0rteKuHaUuXpTYy
 CRqCVAKqFJtxhvJvaX0vLS1Z2dwtDwhjfIdgPiKEGOgCNGH7R8l+aaM4OPOd
Message-ID: <191a4b86-3921-e72c-998d-c490de3ee6e0@amsat.org>
Date:   Wed, 15 Apr 2020 08:43:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200402081614.5696-1-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/20 10:16 AM, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Commit 31168f033e37 ("mips: drop __pXd_offset() macros that duplicate
> pXd_index() ones") is correct that pud_index() & __pud_offset() are the
> same when pud_index() is actually provided, however it does not take into
> account the __PAGETABLE_PUD_FOLDED case. This has broken MIPS KVM
> compilation because it relied on availability of pud_index().
> 
> Define pud_index() regardless of page table folded. It will evaluate to
> actual index for 4-level pagetables and to 0 for folded PUD level.
> 
> Link: https://lore.kernel.org/lkml/20200331154749.5457-1-pbonzini@redhat.com
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

> ---
>  arch/mips/include/asm/pgtable-64.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
> index f92716cfa4f4..ee5dc0c145b9 100644
> --- a/arch/mips/include/asm/pgtable-64.h
> +++ b/arch/mips/include/asm/pgtable-64.h
> @@ -172,6 +172,8 @@
>  
>  extern pte_t invalid_pte_table[PTRS_PER_PTE];
>  
> +#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> +
>  #ifndef __PAGETABLE_PUD_FOLDED
>  /*
>   * For 4-level pagetables we defines these ourselves, for 3-level the
> @@ -210,8 +212,6 @@ static inline void p4d_clear(p4d_t *p4dp)
>  	p4d_val(*p4dp) = (unsigned long)invalid_pud_table;
>  }
>  
> -#define pud_index(address)	(((address) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> -
>  static inline unsigned long p4d_page_vaddr(p4d_t p4d)
>  {
>  	return p4d_val(p4d);
> 
