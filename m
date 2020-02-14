Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F2715F960
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgBNW0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:26:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42827 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgBNW0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581719205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zi+FAk6+B1tEDdQPEK9hBxVo2EUuPbQZvG2bbkdWBcE=;
        b=fFBTH0lHuEWpei7ly0GeS2/BMvVegejNUVoVI0gEpoPtsP+okdGa1xBO1WHLV2cGp7QuP/
        HPtv8rCioVf4cM6jgLTEuqja0GmMBmpVW3lMP1lQIW5BgcOcu1ag35B1CKQGznhYPhjPpt
        VFe4Dt8kWp/irbwQzYX5huafDGrsBgY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-AAb6qsp6M2qxyxqpyB9AmQ-1; Fri, 14 Feb 2020 17:26:44 -0500
X-MC-Unique: AAb6qsp6M2qxyxqpyB9AmQ-1
Received: by mail-qv1-f72.google.com with SMTP id n11so6661353qvp.15
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 14:26:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zi+FAk6+B1tEDdQPEK9hBxVo2EUuPbQZvG2bbkdWBcE=;
        b=mGZoMRJlj0CcEaWW69dCweQY30SNyW+KoekARsUI7tXnH8xmkslFftCyrL6pSaoaOV
         oHj8mt2v8ihdBgDoQKNkH+TLDY0vXzMJ0WgVOOTsiAuPgWBjYR8GSNApwfITHlRNdOml
         TLF2DwiQv0njfOo89dalBpD20yhG5gbq5frca2HbWNY5vxCa2RyZRzfgYqWn+PyaD3O1
         zyxuybQyyW1UHG4GleY69AxyTg1qTIingznx2GDuJ2gTdSd2hf34aCLdK2wnFS6XGOX6
         apLT+5MaqIrN/Fa0aei29BlQFshjRydho6ks8OqB5He2MjBrjP9X7Pzzlt9FqmqibLOR
         gkdg==
X-Gm-Message-State: APjAAAWjjRTGWwzPpDqcwcUqMr5vZY2ouA0EQp0x22+9G0FXxhVuyeH+
        KkClxc6Kk86M31izmDSCvZ+SclSIml+vRisjYABKfIJE46YxMJTpd+hKP3bEZPNIvIN8Qi2aOn+
        8u4koKB1zC4UR
X-Received: by 2002:ac8:176b:: with SMTP id u40mr4497501qtk.272.1581719202256;
        Fri, 14 Feb 2020 14:26:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwWs2UO5Nf1jK+xyGw6/TqetiujeGHCYaXaOLmPWYECnM7OjFY8i2I+Px3Qs0O38aQSXDRBRA==
X-Received: by 2002:ac8:176b:: with SMTP id u40mr4497484qtk.272.1581719201973;
        Fri, 14 Feb 2020 14:26:41 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d16sm23923qkc.132.2020.02.14.14.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 14:26:41 -0800 (PST)
Date:   Fri, 14 Feb 2020 17:26:39 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH 00/13] KVM: selftests: Various fixes and cleanups
Message-ID: <20200214222639.GB1195634@xz-x1>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 03:59:07PM +0100, Andrew Jones wrote:
> This series has several parts:
> 
>  * First, a hack to get x86 to compile. The missing __NR_userfaultfd
>    define should be fixed a better way.

Yeh otherwise I think it will only compile on x86_64.

My gut feeling is we've got an artificial unistd_{32|64}.h under tools
that is included rather than the real one that we should include
(which should locate under $LINUX_ROOT/usr/include/asm/).  Below patch
worked for me, but I'm not 100% sure whether I fixed all the current
users of that artifact header just in case I'll break some (what I saw
is only this evsel.c and another setns.c, while that setns.c has
syscall.h included correct so it seems fine):

diff --git a/tools/arch/x86/include/asm/unistd_32.h b/tools/arch/x86/include/asm/unistd_32.h
deleted file mode 100644
index 60a89dba01b6..000000000000
--- a/tools/arch/x86/include/asm/unistd_32.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __NR_perf_event_open
-# define __NR_perf_event_open 336
-#endif
-#ifndef __NR_futex
-# define __NR_futex 240
-#endif
-#ifndef __NR_gettid
-# define __NR_gettid 224
-#endif
-#ifndef __NR_getcpu
-# define __NR_getcpu 318
-#endif
-#ifndef __NR_setns
-# define __NR_setns 346
-#endif
diff --git a/tools/arch/x86/include/asm/unistd_64.h b/tools/arch/x86/include/asm/unistd_64.h
deleted file mode 100644
index cb52a3a8b8fc..000000000000
--- a/tools/arch/x86/include/asm/unistd_64.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __NR_perf_event_open
-# define __NR_perf_event_open 298
-#endif
-#ifndef __NR_futex
-# define __NR_futex 202
-#endif
-#ifndef __NR_gettid
-# define __NR_gettid 186
-#endif
-#ifndef __NR_getcpu
-# define __NR_getcpu 309
-#endif
-#ifndef __NR_setns
-#define __NR_setns 308
-#endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a69e64236120..f4075392dcb6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -21,6 +21,7 @@
 #include <sys/ioctl.h>
 #include <sys/resource.h>
 #include <sys/types.h>
+#include <sys/syscall.h>
 #include <dirent.h>
 #include <stdlib.h>
 #include <perf/evsel.h>

-- 
Peter Xu

