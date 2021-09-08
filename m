Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428704040A3
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhIHVpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhIHVpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:45:40 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A467C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:44:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a591700b001976d2db364so2525104pji.2
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zsA8il01twTeSknKHQ0jj8qw1HgsEMZMVBVmXBqNklM=;
        b=izA+W/POJn0TO3YyivXFQwBxG7GtB7aZ2aDzkGcMXTnOwyLlsuASxf904lJpAwbpSS
         RzpuzA8+9uCunN5kkfUeOKYsgJ8GCd4cbP4+aP17wYIVYiM/HB8E+U3c5nmaV3pIvJQe
         AA3F/bRfUBxVbQsn4lE52UoghxmqvzocKxHQBzqhqnUE+yLPTyBZ3YZX6axvcZTNe/B5
         rcBk+eEEfmZjeVtYtEOksyW3oQSpf3MBsUTln/syJClyW56anhK3XMC4RnSOUF7m1YXI
         W7kbu/Z8Y/uhQd5vIwS5i2rl+GHoYKuilb5eDzF3Z/zaHVLp30VcfER3Xtjj/iEJmfte
         sdNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zsA8il01twTeSknKHQ0jj8qw1HgsEMZMVBVmXBqNklM=;
        b=c4onjzf9DXiVHIfE1fv5sNMBnggKjHoBGbmo9QgpMIdzRyKvWpZcdsC0ChlzzFlrTm
         oSsTMJGJiBHS8k2lIPoQojqWlRBTf0JfLKyBDGqC7cF8sqDjKtdW8aTltv0qBtKymxOM
         IsBh9WgPvZDzVOoI8O8bv/VizZN3fCHLKEnIaMlsvev3PbagUS863/xPbfABdOqLs4Mv
         potaUChA/60kLddVQuo5gJAPnjpX6PTz3euZYY/OKtSTHbTNznu0TIACMc+L2TLupIRa
         WVWfaslMfKlBPEGwA6ipHRhxjZz6UiXIFZEMytedSy23M84QJCQUdHCtiVxZfs+rblSA
         OOBw==
X-Gm-Message-State: AOAM53098rcf++RH6T7O6Bc5dwsQScHv7eAmY+rdCGNroHZQHMq8K3Dr
        bywUXrb5VOFxCqRdr3y8vACYxQ==
X-Google-Smtp-Source: ABdhPJwgKy8iOS2sRSXQ17fx8P1ScqVyj+iSgCr/0OAaLfZpuf5VYx4QZ/QezEJcuV7JYgmttvo+WQ==
X-Received: by 2002:a17:90b:38c7:: with SMTP id nn7mr337316pjb.38.1631137471593;
        Wed, 08 Sep 2021 14:44:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6sm136634pfi.220.2021.09.08.14.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 14:44:31 -0700 (PDT)
Date:   Wed, 8 Sep 2021 21:44:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/5] libcflag: define the "noinline"
 macro
Message-ID: <YTkuuxUfMLRViCT6@google.com>
References: <20210825222604.2659360-1-morbo@google.com>
 <20210908204541.3632269-1-morbo@google.com>
 <20210908204541.3632269-2-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908204541.3632269-2-morbo@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021, Bill Wendling wrote:
> Define "noline" macro to reduce the amount of typing for functions using
> the "noinline" attribute.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
