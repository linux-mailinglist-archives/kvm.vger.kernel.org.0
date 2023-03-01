Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE906A7728
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 23:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCAW7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 17:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAW7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 17:59:48 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF7861A7;
        Wed,  1 Mar 2023 14:59:47 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id s22so19763504lfi.9;
        Wed, 01 Mar 2023 14:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677711585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cq6JtszAd/uLsfuDjslZ5BwQBYc2QLNd/Q/ORRtI1lk=;
        b=dfpYmq2PNG54SS8ia04DO+uL3grlthWKLD89howZ36X8GU27v5TLvRGdGW+t8dWOB4
         Se8NRZNEsbPggEVS1ckF9FE1TZFkXtOyLkrFwtypJIpHPUOdcLQzxePKavB9l9/AEvqp
         gaULyNyQq8cgP8VfINqkq941ljoJP4C0A3rK4x6doXeHSGLbeK6ylBQaQTnv8e0EPLYG
         s9z7mFCZZbe7Wusc0nRDPIGi2yr7ynSL1Pm8WZuERUWU/DC3KpKVQ7auHgzdHVV9OXLJ
         5P00d882SJsNjuG4uziCxFwDNg7Woq3O5MA7MtYov2N7EENwtWwvDiXkdIuC+twRxZDy
         /foA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677711585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cq6JtszAd/uLsfuDjslZ5BwQBYc2QLNd/Q/ORRtI1lk=;
        b=dWCN1UhvmJ/KidG6CMhWiibibkUB7alDCY1Gb/ZNYHntDOJONLjUANSVegi+I0Qbz5
         ZSVlXbEsM//0koTN6Y3wJjX6G+NGtZPH0Rdvan0WSL3oxZjTYjDpAgmX0pSjE0nZxjgL
         cZ6wQPR8tZQDOfiRwmbqMzVlXOrR0w0cRCDaRhF9mYnYniVmibsxIQTh51654RJ9w4pX
         OzSEIHjSnT/yEMvd8enjzEBALTmym4dFNPYa2llVpFeEfkVD0jSuDZhYQew0CItzUe9w
         RRRnrexviukQP2CDRbbrB2TTHkZ+ESqQdv5vGYbWQNWXg+SBcGURFlK+/akTa/4lokfj
         TPRg==
X-Gm-Message-State: AO0yUKUm0IUOu8C7G4zIw1CRFr+q0FLm/ReaedJtbeBQ76H93Rk4gDNU
        jYTTfhXwjsRiyrXt+hg1BhU=
X-Google-Smtp-Source: AK7set/BPYqdOnbeAKkU76dP9CqqweuXat20Hca70pdpT2iKMrvQVVaWiZHBqH7PbYNMVYfwqF/KoA==
X-Received: by 2002:ac2:5197:0:b0:4b5:3e6e:382e with SMTP id u23-20020ac25197000000b004b53e6e382emr1951450lfi.4.1677711585446;
        Wed, 01 Mar 2023 14:59:45 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id h5-20020a05651211c500b004dc48d91061sm1892988lfr.304.2023.03.01.14.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 14:59:45 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Thu, 2 Mar 2023 00:59:43 +0200
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
Subject: Re: [PATCH RFC v8 00/56] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <20230302005943.00001a8e@intel.com>
In-Reply-To: <f2c904f6-996a-e903-5d56-662781567578@intel.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <f2c904f6-996a-e903-5d56-662781567578@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Mar 2023 08:56:05 -0800
Dave Hansen <dave.hansen@intel.com> wrote:

> On 2/20/23 10:37, Michael Roth wrote:
> > The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
> > access requires an RMP check. In particular, the read accesses from the
> > hypervisor do not require RMP checks because the data confidentiality is
> > already protected via memory encryption. When hardware encounters an RMP
> > checks failure, it raises a page-fault exception. If RMP check failure
> > is due to the page-size mismatch, then split the large page to resolve
> > the fault.
> 
> What does this all _mean_?
>

Unlike TDX which implements secure EPT to hold the restricted memory mapping,
SEV-SNP is still using one NPT (similar to Intel EPT) while adding another
level of HW-enforced check controlled by the "RMP" table. Similar to TDX,
it has firmware calls to modify the attributes in the RMP table to achieve
isolation and shared-private memory conversion. 

The purpose and structure of RMP is quite similar to the PAMT table in TDX from
the perspective of managing the per-page attributes. Each system page has a
collection of attribute bits. But TDX only uses the PAMT as metadata as it has
a separate secure EPT to achieve HW-enforced check.

The RMP memory access checks has its own schematics. E.g. data write,
page table access from VMM will be checked, but data read is not, mostly
I guess, due to performance consideration. More details can be found from
Table 15-39. RMP Memory Access Checks in [1].

> When does the kernel need to care about a "page-size mismatch"?

The RMP table has the ability to describe a large page (similar to a large page
with a description of large-page PAMT entry in TDX that can be demoted via
TDX SEAMCALLs). E.g. 2MB page.

When the userspace sets the memory attribute of a GFN range through the
restricted memory ioctl, the sev logic (sev_update_mem_attr() in PATCH 48, to
be precise) will try to build a large page description in the RMP table if the
PFNs are continuous. When kernel mm breaks the the large page due to THP, KVM
updates the NPT accordingly.

Then there will be a page-size mismatch between NPT and RMP. It will be
resolved by a RMP fault later. Kinda of lazy sync.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf
