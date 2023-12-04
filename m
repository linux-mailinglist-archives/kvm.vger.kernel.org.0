Return-Path: <kvm+bounces-3402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 281CB803D82
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA4211F2110E
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2098730650;
	Mon,  4 Dec 2023 18:51:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2a07:de40:b251:101:10:150:64:2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D096AF;
	Mon,  4 Dec 2023 10:51:04 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 14A361FE6A;
	Mon,  4 Dec 2023 18:51:02 +0000 (UTC)
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id F113513B65;
	Mon,  4 Dec 2023 18:51:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id dGqaOpUfbmXlYQAAn2gu4w
	(envelope-from <jack@suse.cz>); Mon, 04 Dec 2023 18:51:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6870FA07DB; Mon,  4 Dec 2023 19:51:01 +0100 (CET)
Date: Mon, 4 Dec 2023 19:51:01 +0100
From: Jan Kara <jack@suse.cz>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Disseldorp <ddiss@suse.de>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
	Jiri Pirko <jiri@resnulli.us>, Jiri Slaby <jirislaby@kernel.org>,
	Kalle Valo <kvalo@kernel.org>, Karsten Graul <kgraul@linux.ibm.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Kees Cook <keescook@chromium.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Neukum <oneukum@suse.com>, Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ping-Ke Shih <pkshih@realtek.com>, Rich Felker <dalias@libc.org>,
	Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	GR-QLogic-Storage-Upstream@marvell.com, alsa-devel@alsa-project.org,
	ath10k@lists.infradead.org, dmaengine@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-net-drivers@amd.com, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-sound@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mpi3mr-linuxdrv.pdl@broadcom.com,
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
	Jan Kara <jack@suse.cz>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Matthew Wilcox <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Maxim Kuvyrkov <maxim.kuvyrkov@linaro.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH v2 00/35] bitops: add atomic find_bit() operations
Message-ID: <20231204185101.ddmkvsr2xxsmoh2u@quack3>
References: <20231203192422.539300-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231203192422.539300-1-yury.norov@gmail.com>
X-Spamd-Bar: ++++++++++++++
X-Spam-Score: 14.88
X-Rspamd-Server: rspamd1
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	spf=softfail (smtp-out2.suse.de: 2a07:de40:b281:104:10:150:64:98 is neither permitted nor denied by domain of jack@suse.cz) smtp.mailfrom=jack@suse.cz;
	dmarc=none
X-Rspamd-Queue-Id: 14A361FE6A
X-Spamd-Result: default: False [14.88 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 TO_DN_SOME(0.00)[];
	 R_SPF_SOFTFAIL(4.60)[~all];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_GT_50(0.00)[100];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 FORGED_RECIPIENTS(2.00)[m:yury.norov@gmail.com,m:davem@davemloft.net,m:jejb@linux.ibm.com,m:haris.iqbal@ionos.com,m:akinobu.mita@gmail.com,m:akpm@linux-foundation.org,m:andersson@kernel.org,m:bp@alien8.de,m:brauner@kernel.org,m:dave.hansen@linux.intel.com,m:ecree.xilinx@gmail.com,m:edumazet@google.com,m:fenghua.yu@intel.com,m:geert@linux-m68k.org,m:gregory.greenman@intel.com,m:hughd@google.com,m:kuba@kernel.org,m:axboe@kernel.dk,m:jirislaby@kernel.org,m:kvalo@kernel.org,m:kgraul@linux.ibm.com,m:isdn@linux-pingi.de,m:keescook@chromium.org,m:leon@kernel.org,m:mark.rutland@arm.com,m:habetsm.xilinx@gmail.com,m:mchehab@kernel.org,m:mpe@ellerman.id.au,m:npiggin@gmail.com,m:peterz@infradead.org,m:dalias@libc.org,m:robh@kernel.org,m:robin.murphy@arm.com,m:seanjc@google.com,m:xueshuai@linux.alibaba.com,m:rostedt@goodmis.org,m:tsbogend@alpha.franken.de,m:tglx@linutronix.de,m:wenjia@linux.ibm.com,m:will@kernel.org,m:alsa-devel@alsa-project.org,m:linux-net-drivers@amd.com,m:mpi3mr-linuxdrv.pdl
 @broadcom.com,m:x86@kernel.org,m:mirsad.todorovac@alu.unizg.hr,m:willy@infradead.org,m:andriy.shevchenko@linux.intel.com,m:maxim.kuvyrkov@linaro.org,m:klimov.linux@gmail.com,m:bvanassche@acm.org,s:s.shtylyov@omp.ru];
	 BAYES_HAM(-3.00)[100.00%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[wp.pl,xs4all.nl];
	 NEURAL_SPAM_SHORT(2.49)[0.832];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.cz];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[vger.kernel.org,davemloft.net,zytor.com,linux.ibm.com,microsoft.com,ionos.com,gmail.com,linux-foundation.org,kernel.org,alien8.de,nvidia.com,opensource.wdc.com,linux.intel.com,suse.de,google.com,intel.com,linux-m68k.org,linuxfoundation.org,xs4all.nl,redhat.com,perex.cz,ziepe.ca,kernel.dk,resnulli.us,linux-pingi.de,chromium.org,arm.com,ellerman.id.au,monstr.eu,suse.com,infradead.org,realtek.com,libc.org,linux.alibaba.com,wp.pl,goodmis.org,alpha.franken.de,linutronix.de,users.sourceforge.jp,marvell.com,alsa-project.org,lists.infradead.org,lists.linux.dev,lists.linux-m68k.org,amd.com,lists.ozlabs.org,broadcom.com,suse.cz,alu.unizg.hr,rasmusvillemoes.dk,linaro.org,acm.org,omp.ru];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]

Hello Yury!

On Sun 03-12-23 11:23:47, Yury Norov wrote:
> Add helpers around test_and_{set,clear}_bit() that allow to search for
> clear or set bits and flip them atomically.
> 
> The target patterns may look like this:
> 
> 	for (idx = 0; idx < nbits; idx++)
> 		if (test_and_clear_bit(idx, bitmap))
> 			do_something(idx);
> 
> Or like this:
> 
> 	do {
> 		bit = find_first_bit(bitmap, nbits);
> 		if (bit >= nbits)
> 			return nbits;
> 	} while (!test_and_clear_bit(bit, bitmap));
> 	return bit;
> 
> In both cases, the opencoded loop may be converted to a single function
> or iterator call. Correspondingly:
> 
> 	for_each_test_and_clear_bit(idx, bitmap, nbits)
> 		do_something(idx);
> 
> Or:
> 	return find_and_clear_bit(bitmap, nbits);

These are fine cleanups but they actually don't address the case that has
triggered all these changes - namely the xarray use of find_next_bit() in
xas_find_chunk().

...
> This series is a result of discussion [1]. All find_bit() functions imply
> exclusive access to the bitmaps. However, KCSAN reports quite a number
> of warnings related to find_bit() API. Some of them are not pointing
> to real bugs because in many situations people intentionally allow
> concurrent bitmap operations.
> 
> If so, find_bit() can be annotated such that KCSAN will ignore it:
> 
>         bit = data_race(find_first_bit(bitmap, nbits));

No, this is not a correct thing to do. If concurrent bitmap changes can
happen, find_first_bit() as it is currently implemented isn't ever a safe
choice because it can call __ffs(0) which is dangerous as you properly note
above. I proposed adding READ_ONCE() into find_first_bit() / find_next_bit()
implementation to fix this issue but you disliked that. So other option we
have is adding find_first_bit() and find_next_bit() variants that take
volatile 'addr' and we have to use these in code like xas_find_chunk()
which cannot be converted to your new helpers.

> This series addresses the other important case where people really need
> atomic find ops. As the following patches show, the resulting code
> looks safer and more verbose comparing to opencoded loops followed by
> atomic bit flips.
> 
> In [1] Mirsad reported 2% slowdown in a single-thread search test when
> switching find_bit() function to treat bitmaps as volatile arrays. On
> the other hand, kernel robot in the same thread reported +3.7% to the
> performance of will-it-scale.per_thread_ops test.

It was actually me who reported the regression here [2] but whatever :)

[2] https://lore.kernel.org/all/20231011150252.32737-1-jack@suse.cz

> Assuming that our compilers are sane and generate better code against
> properly annotated data, the above discrepancy doesn't look weird. When
> running on non-volatile bitmaps, plain find_bit() outperforms atomic
> find_and_bit(), and vice-versa.
> 
> So, all users of find_bit() API, where heavy concurrency is expected,
> are encouraged to switch to atomic find_and_bit() as appropriate.

Well, all users where any concurrency can happen should switch. Otherwise
they are prone to the (admittedly mostly theoretical) data race issue.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

