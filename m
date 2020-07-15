Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06992201BD
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 03:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGOBXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 21:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgGOBXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 21:23:17 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9008FC061794
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:23:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so641547pfn.12
        for <kvm@vger.kernel.org>; Tue, 14 Jul 2020 18:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NT375/NWnBuLf4KzmogX9uCvmnJa241H/PijGYCo0Rk=;
        b=bimL89L0BNwd4ir3o2j2V/AyCZ2jVBpqFkU8fi/kDsbmwoDWfcozJeb3xUXgm++f9+
         1U8Y1/W2AS591JgD3TETxDCp/+qzMH2RffI2AGu37PYQLqP9cI6PXEVdUuxRX36GauNw
         dKzr1hUEyzapgzl8H0hVFH+9sUvWDXwzCjRLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NT375/NWnBuLf4KzmogX9uCvmnJa241H/PijGYCo0Rk=;
        b=o2vYXynL5VwA9/dKF15y4EQ4RuEyjOmNR+9tap1Yan9OYOwMzZeLu+lt1XXJoMrS1x
         l9NHwFFUyhvq3hxyOmsLcu7CvpKtbPd5d+I5+c0uxyfOkcRdDLEQMTCsoQa+IYM+rOPj
         DMvLx1mZfd16Nj6CcC6cbGyf8ZlkBNqpoJzw3GEndJkSRebzYrCXb18rexuuM6LuJJ66
         YE/arUdJ/SpXa+q58seaABqz8CCjWi0yi2SZ28+yeIs4umYkz9vBJYLyHaJIICIoosdw
         X1NqUO5gq3XTzH51ShTJxrhOXmAcc2ub8EIZh/l3QGABVQCw8cmd6aq6I8nukCDRpbp/
         lFrw==
X-Gm-Message-State: AOAM530DD0bfEtmi4WDQMvKkZQIB7FSjTU/RAgru5NcYucGOxx3toNIn
        yVV+BSzxYefb1cvw5kjThZqS1w==
X-Google-Smtp-Source: ABdhPJzfbFkAdUV1tVZNSCYI/nTLerjov6WaHg2IDFRE3YJozMZNUHsxrGh7aJib+qaIcupcJ1NajA==
X-Received: by 2002:a63:405:: with SMTP id 5mr5473617pge.449.1594776196084;
        Tue, 14 Jul 2020 18:23:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d4sm306378pgf.9.2020.07.14.18.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 18:23:15 -0700 (PDT)
Date:   Tue, 14 Jul 2020 18:23:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 13/75] x86/boot/compressed/64: Rename kaslr_64.c to
 ident_map_64.c
Message-ID: <202007141823.65F31DE0@keescook>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-14-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-14-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:15PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The file contains only code related to identity mapped page-tables.
> Rename the file and compile it always in.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
