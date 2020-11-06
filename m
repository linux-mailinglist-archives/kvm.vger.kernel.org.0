Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF742A93C1
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgKFKJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFKJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 05:09:37 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D943EC0613CF;
        Fri,  6 Nov 2020 02:09:36 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z3so876270pfz.6;
        Fri, 06 Nov 2020 02:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=7oxBE7G3KdNo8V3DlQixQTNnTK096vj3MYEkKh/2CDY=;
        b=uCquK5wR7b3Q3HrX48s5xeH4JyLCKFZe0iR04nZ1WCFCtSqboVUG58LVKkrRO2EfGt
         O/8gt2kWtsea3jaVzqaGdPupjyraKnBa/pWXwalT4V/EGWCRiHjUXOxrH+Q8vihlKPVr
         DS+taIBHyZsy/Vq3lgTgyRBXIoF71eDRr4nlESHozpnh9N0PRzRRGILt1T7/P21/KpZi
         EYIPZ1ZHF173vyiW58JBLY0JMghS2qI+2bekYy1nKIpd2M3sH8fAD/3kZp60XL7r+FIQ
         HMOCu5cUd1d1tLTM02GvMPzKS1kYJ2lMpI4xNnff6uj2+WBKR0fh+5fsVhoNtp3zhMDG
         TRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7oxBE7G3KdNo8V3DlQixQTNnTK096vj3MYEkKh/2CDY=;
        b=M3ZIdl4mmDPzjJEvLY89i+NEqUt03lhke3J3FItpyAhzkPfB3XYqB/rrnhNIS38S/3
         adDrj1i3Pfv6liigR7AALjNItVAr5KR3ftBF1bl9alOiZSlb+7g3nj4pw3u7Z76rqtER
         BNJdZa/rG3FrVY7JRf6ZEtsDIwODrMfolDp+MfURmU5DdCEa4GNkDDHUUWWWWoEbO8Z2
         gVDCZiBJj8ox8eUapLLqk4RkdEgCWbXbJk2nmmYIw2EB9WTiqEB6aEfFVkjgVTpqsoYE
         fpkZdSAjJtivXWR+J9Dg444oWZt8zNrFiXxi33Dk7WDFVNOriRXJ9yUSHGatSvSbIVCN
         SuXQ==
X-Gm-Message-State: AOAM532dc1go9+nBK2gNTQo44t/NxTbAJj238IZ8dg8khA6lUJWcNz1G
        ORxIwgM5L4PoryzczrVzwD4=
X-Google-Smtp-Source: ABdhPJzJM3j6lsDf77K+QOGo1bUayGKTY5lAo5kbRUZfR0myUfQOG324lr3gWaHWSyhIFLA0WjTYlA==
X-Received: by 2002:a63:934c:: with SMTP id w12mr1139016pgm.114.1604657376456;
        Fri, 06 Nov 2020 02:09:36 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e14sm1194384pga.61.2020.11.06.02.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 02:09:35 -0800 (PST)
Date:   Fri, 6 Nov 2020 18:09:29 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     linux-next@vger.kernel.org
Subject: linux-next arm64 kvm build error
Message-ID: <20201106100929.pllgrxcdj3xjx47a@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

It's introduced by this commit:
    KVM: arm64: Use fallback mapping sizes for contiguous huge page sizes
and blocking further test.

arch/arm64/kvm/mmu.c:798:2: error: duplicate case value
  case PMD_SHIFT:
  ^~~~

Thanks,
-- 
Murphy
