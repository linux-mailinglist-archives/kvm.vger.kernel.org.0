Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0AA276EC4
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 12:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgIXKa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 06:30:58 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:40324 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727349AbgIXKa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 06:30:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CE44F57D54;
        Thu, 24 Sep 2020 10:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1600943454;
         x=1602757855; bh=3mGLLevBBfEc5p6XO79c/9Q11lMdjRKkb8bb753Hfy4=; b=
        FB9QzUQoMC7+1k8Ke+oSE6HuAhTe+1St7uboOrgfcExNto20G/qE3q4U6F8ubpuE
        LVAayvaNx1O0rxVz9e4vOQYPee0g2Fax4dWojeANprBLonRHM49ys1VZOL/GS3nl
        1EpOHchREV4kZDUzy7zlhow0QBN0ZHFza48aErWRA88=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QddTxFNbaNoG; Thu, 24 Sep 2020 13:30:54 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DDE13579F2;
        Thu, 24 Sep 2020 13:30:54 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 24
 Sep 2020 13:30:54 +0300
Date:   Thu, 24 Sep 2020 13:30:54 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
Message-ID: <20200924103054.GA69137@SPB-NB-133.local>
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
 <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 12:18:04PM +0200, Paolo Bonzini wrote:
> On 24/09/20 12:06, Roman Bolshakov wrote:
> > 83760814f637 ("configure: Check for new-enough getopt") has replaced
> > proposed patch and doesn't introduce --getopt option in configure.
> > Instead, `configure` and `run_tests.sh` expect proper getopt to be
> > available in PATH.
> 
> Is this because getopt is "keg only"?  I thought you could just add
> `brew --prefix`/bin to the path.  You can also do "brew link" if there
> are no backwards-compatibility issues.
> 

Yes, keg-only packages do not shadow system utilities (which either come
from FreeBSD or GNU but have the most recent GPL2 version, i.e. quite
old), so adding `brew --prefix`/bin to PATH doesn't help much.

brew link doesn't help either :)

$ brew link gnu-getopt

Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
If you need to have gnu-getopt first in your PATH run:
  echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc

Thanks,
Roman
