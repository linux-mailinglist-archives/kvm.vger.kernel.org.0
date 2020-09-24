Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA67B276F01
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgIXKsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 06:48:40 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:41300 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbgIXKsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 06:48:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C933357E35;
        Thu, 24 Sep 2020 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received;
         s=mta-01; t=1600944517; x=1602758918; bh=yjRVJRbp3nJ4kjAq7dFJYC
        FA7WhlSmQxh7D3/yXLc0Q=; b=lTBokx43jECRormMjfdOF4uWeb5gCRvxMQMXcF
        szB34iJqJr/klN0XajQ/bx4hmnDocqX14BEzAPqVSAkpAv4heDVGNWyCJmZ9iVca
        qf7Vo4HmPcNI/UZ3cuHLSF5Pt9d2iys2mEGAYPi3uyXUSfm7H4UcJYFJSlu7FOFn
        3fbyU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JQnVBLAsuw9G; Thu, 24 Sep 2020 13:48:37 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4346057D54;
        Thu, 24 Sep 2020 13:48:37 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 24
 Sep 2020 13:48:37 +0300
Date:   Thu, 24 Sep 2020 13:48:36 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
Message-ID: <20200924104836.GB69137@SPB-NB-133.local>
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
 <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
 <20200924103054.GA69137@SPB-NB-133.local>
 <7e0b838b-2a6d-b370-e031-8d804c23b822@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e0b838b-2a6d-b370-e031-8d804c23b822@redhat.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 12:34:28PM +0200, Paolo Bonzini wrote:
> On 24/09/20 12:30, Roman Bolshakov wrote:
> > Yes, keg-only packages do not shadow system utilities (which either come
> > from FreeBSD or GNU but have the most recent GPL2 version, i.e. quite
> > old), so adding `brew --prefix`/bin to PATH doesn't help much.
> > 
> > brew link doesn't help either :)
> > 
> > $ brew link gnu-getopt
> > 
> > Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
> > If you need to have gnu-getopt first in your PATH run:
> >   echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
> 
> Oh, that's not what https://docs.brew.sh/FAQ says:
> 
> -----
> What does “keg-only” mean?
> 
> It means the formula is installed only into the Cellar and is not linked
> into /usr/local. This means most tools will not find it. You can see why
> a formula was installed as keg-only, and instructions to include it in
> your PATH, by running brew info <formula>.
> 
> You can still link in the formula if you need to with brew link
> <formula>, though this can cause unexpected behaviour if you are
> shadowing macOS software.
> -----
> 
> Apparently you need --force.
> 

Unfortunately it has no effect (and I wouldn't want to do that to avoid
issues with other scripts/software that implicitly depend on native
utilities):

$ brew link --force gnu-getopt
Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
If you need to have gnu-getopt first in your PATH run:
  echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc

So if it's possible I'd still prefer to add an option to specify
--getopt in configure. I can resend a patch for that.

Thanks,
Roman
