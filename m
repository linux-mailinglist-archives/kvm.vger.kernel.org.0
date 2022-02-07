Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731994ACB07
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiBGVNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiBGVNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:13:33 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33111C06173B
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:13:33 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i30so15171246pfk.8
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dgfVPCD1yFcWd6usf6tyzbTDlskTBR+84CZeMxHcxUA=;
        b=CFy2MeRUSD4l2J9SaOg0DkGxjipYw3+/aFM2jGcC/8BLRNwtk7L2q/LinybBIheDTA
         2AtZMIVNzgT5zMpAxHE/eJlx1uW6HRJ+Sb1t3DptQMv+lL/rwIXZxnk+4pPRWdt9xL8N
         sPYILHn7/cedodX6pedgiTnuJ6XKcE/+9qg73NTdG/vgoanyERRrCUGc4Dbp0H4ZW+x1
         uDLNJ7ISJtIJFmFgU+tt4UBUpgeAmsKq9TfkrswKiBxu5f/8FeHmdPTITpnx1w5oTWZL
         yXfJAP81asK3PLz286L1MHPt6wBBBa2mr5F29idjXaB3lDkwpQ8CZZdmDkJuzGV3ngsl
         e+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dgfVPCD1yFcWd6usf6tyzbTDlskTBR+84CZeMxHcxUA=;
        b=bOIQh+FpcDe9DCEhfQ+Qax6JW/j2vK64kM+UrboBLRZ4coCJe0cpUZ26ktiYPr6pRm
         s3C3Mkln2BNWvXgKI8hq0DRUqd2HzsHU58hZotBEz+vQZ59/1DifQ9SLFBa0Ws+VQp/N
         cbO5Pp84stS61IodrdrJgimlSzYmL1agPgeuvQcIZCN201Gp0oYHJH6qlbcsfT9SQf/n
         jsP88RzLV49TW2n6ScUEuLVa0xgvVX2nResafYWJCWDib606jtqLjzn/qzlKmzEJ1oBG
         EHszfXOLpb9VnIS6HYKNUsnifeYaXxPpopKx2ls8U/0GSun+4iY8297qxmQ/NhFpdaPZ
         qp8g==
X-Gm-Message-State: AOAM533KYI7R+K88WylYJXCEvpNxjNRaudV7LR4GzVugiCuE9ZqN/q3x
        JSL+4+atxUlvkCR/qt2yOBOXIA==
X-Google-Smtp-Source: ABdhPJw1csCsJjtIFRMFl4FPSyeaZZbh9COpz15Ag+k6FKlL3BVbnckGMLZbA+SWBxlwQ0IlilAfmw==
X-Received: by 2002:a62:86c1:: with SMTP id x184mr1378445pfd.26.1644268412553;
        Mon, 07 Feb 2022 13:13:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t9sm250184pjg.44.2022.02.07.13.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:13:31 -0800 (PST)
Date:   Mon, 7 Feb 2022 21:13:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests 07/13] x86: AMD SEV-ES: Handle WBINVD #VC
Message-ID: <YgGLeOTdc6oRgVok@google.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-8-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120125122.4633-8-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022, Varad Gautam wrote:
> Add Linux's sev_es_ghcb_hv_call helper to allow VMGEXIT from the #VC
> handler, and handle SVM_EXIT_WBINVD using this.

There are no WBINVDs in KUT outside of nVMX or nSVM tests, and there never should
be.  I.e. this patch is unnecessary.
