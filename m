Return-Path: <kvm+bounces-2897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD037FEECC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5A1BB20E1A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 12:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689FC4644E;
	Thu, 30 Nov 2023 12:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C108B9A
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 04:20:30 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 287A721AE3;
	Thu, 30 Nov 2023 12:20:29 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3772E1342E;
	Thu, 30 Nov 2023 12:20:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fDWBDQx+aGUXLQAAD6G6ig
	(envelope-from <farosas@suse.de>); Thu, 30 Nov 2023 12:20:28 +0000
From: Fabiano Rosas <farosas@suse.de>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>, qemu-s390x@nongnu.org,
 Song Gao <gaosong@loongson.cn>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Thomas Huth <thuth@redhat.com>, Hyman Huang
 <yong.huang@smartx.com>, Marcelo Tosatti <mtosatti@redhat.com>, David
 Woodhouse <dwmw2@infradead.org>, Andrey Smirnov
 <andrew.smirnov@gmail.com>, Peter Maydell <peter.maydell@linaro.org>,
 Kevin Wolf <kwolf@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Artyom Tarasenko <atar4qemu@gmail.com>, Mark Cave-Ayland
 <mark.cave-ayland@ilande.co.uk>, Max Filippov <jcmvbkbc@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>, Paul Durrant <paul@xen.org>,
 Jagannathan Raman <jag.raman@oracle.com>, Juan Quintela
 <quintela@redhat.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>,
 qemu-arm@nongnu.org, Jason Wang <jasowang@redhat.com>, Gerd Hoffmann
 <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, =?utf-8?Q?Marc-Andr?=
 =?utf-8?Q?=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>, BALATON Zoltan <balaton@eik.bme.hu>, Daniel
 Henrique Barboza <danielhb413@gmail.com>, Elena Ufimtseva
 <elena.ufimtseva@oracle.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Hailiang Zhang <zhanghailiang@xfusion.com>, Roman Bolshakov
 <rbolshakov@ddn.com>, Huacai Chen <chenhuacai@kernel.org>, Fam Zheng
 <fam@euphon.net>, Eric Blake <eblake@redhat.com>, Jiri Slaby
 <jslaby@suse.cz>, Alexander Graf <agraf@csgraf.de>, Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>, Weiwei Li <liwei1518@gmail.com>, Eric
 Farman <farman@linux.ibm.com>, Stafford Horne <shorne@gmail.com>, David
 Hildenbrand <david@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org, Pavel
 Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org, Aleksandar
 Rikalo <aleksandar.rikalo@syrmia.com>, John Snow <jsnow@redhat.com>, Sunil
 Muthuswamy <sunilmut@microsoft.com>, Michael Roth <michael.roth@amd.com>,
 David Gibson <david@gibson.dropbear.id.au>, "Michael S. Tsirkin"
 <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Bin
 Meng <bin.meng@windriver.com>, Stefano Stabellini
 <sstabellini@kernel.org>, kvm@vger.kernel.org, Stefan Hajnoczi
 <stefanha@redhat.com>, qemu-block@nongnu.org, Halil Pasic
 <pasic@linux.ibm.com>, Peter Xu <peterx@redhat.com>, Anthony Perard
 <anthony.perard@citrix.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Eduardo Habkost
 <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Vladimir
 Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, =?utf-8?Q?C=C3=A9dric?= Le
 Goater
 <clg@kaod.org>, qemu-ppc@nongnu.org, Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Leonardo Bras
 <leobras@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 1/6] system/cpus: rename qemu_mutex_lock_iothread() to
 qemu_bql_lock()
In-Reply-To: <20231129212625.1051502-2-stefanha@redhat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-2-stefanha@redhat.com>
Date: Thu, 30 Nov 2023 09:20:25 -0300
Message-ID: <87sf4na0vq.fsf@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spamd-Bar: ++++++++++
X-Spam-Score: 10.53
X-Rspamd-Server: rspamd1
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:97 is neither permitted nor denied by domain of farosas@suse.de) smtp.mailfrom=farosas@suse.de;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none)
X-Rspamd-Queue-Id: 287A721AE3
X-Spamd-Result: default: False [10.53 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-0.999];
	 RCPT_COUNT_GT_50(0.00)[78];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.06)[61.02%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_IN_DNSWL_HI(-1.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[];
	 FREEMAIL_CC(0.00)[tribudubois.net,nongnu.org,loongson.cn,gmail.com,redhat.com,smartx.com,infradead.org,linaro.org,linux.ibm.com,ilande.co.uk,wdc.com,xen.org,oracle.com,eik.bme.hu,aurel32.net,xfusion.com,ddn.com,kernel.org,euphon.net,suse.cz,csgraf.de,linux.alibaba.com,netbsd.org,dabbelt.com,apple.com,lists.xenproject.org,ispras.ru,syrmia.com,microsoft.com,amd.com,gibson.dropbear.id.au,windriver.com,vger.kernel.org,citrix.com,habkost.net,yandex-team.ru,kaod.org,daynix.com,flygoat.com]

Stefan Hajnoczi <stefanha@redhat.com> writes:

> The Big QEMU Lock (BQL) has many names and they are confusing. The
> actual QemuMutex variable is called qemu_global_mutex but it's commonly
> referred to as the BQL in discussions and some code comments. The
> locking APIs, however, are called qemu_mutex_lock_iothread() and
> qemu_mutex_unlock_iothread().
>
> The "iothread" name is historic and comes from when the main thread was
> split into into KVM vcpu threads and the "iothread" (now called the main
> loop thread). I have contributed to the confusion myself by introducing
> a separate --object iothread, a separate concept unrelated to the BQL.
>
> The "iothread" name is no longer appropriate for the BQL. Rename the
> locking APIs to:
> - void qemu_bql_lock(void)
> - void qemu_bql_unlock(void)
> - bool qemu_bql_locked(void)
>
> There are more APIs with "iothread" in their names. Subsequent patches
> will rename them. There are also comments and documentation that will be
> updated in later patches.
>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Acked-by: Fabiano Rosas <farosas@suse.de>

