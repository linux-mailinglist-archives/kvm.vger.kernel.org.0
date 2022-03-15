Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2006A4D95B2
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 08:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345701AbiCOHzP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 15 Mar 2022 03:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345693AbiCOHzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 03:55:14 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DA96E0E3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 00:54:02 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-wQ12KsT-PDSqq8y9SNA3Rw-1; Tue, 15 Mar 2022 03:53:56 -0400
X-MC-Unique: wQ12KsT-PDSqq8y9SNA3Rw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25BE18001EA;
        Tue, 15 Mar 2022 07:53:54 +0000 (UTC)
Received: from bahia (unknown [10.39.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED3FC7CB810;
        Tue, 15 Mar 2022 07:53:43 +0000 (UTC)
Date:   Tue, 15 Mar 2022 08:53:42 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Laurent Vivier <lvivier@redhat.com>,
        Amit Shah <amit@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?B?SGVy?= =?UTF-8?B?dsOp?= Poussineau 
        <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Corey Minyard <cminyard@mvista.com>,
        Patrick Venture <venture@google.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?B?Q8Op?= =?UTF-8?B?ZHJpYw==?= Le Goater 
        <clg@kaod.org>, Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        Jean-Christophe Dubois <jcd@tribudubois.net>,
        Keith Busch <kbusch@kernel.org>,
        Klaus Jensen <its@irrelevant.dk>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Eric Blake <eblake@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, xen-devel@lists.xenproject.org,
        qemu-ppc@nongnu.org, qemu-block@nongnu.org, haxm-team@intel.com,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH 2/3] 9pfs: Use g_new() & friends where that makes
 obvious sense
Message-ID: <20220315085342.2b07eff8@bahia>
In-Reply-To: <20220314160108.1440470-3-armbru@redhat.com>
References: <20220314160108.1440470-1-armbru@redhat.com>
        <20220314160108.1440470-3-armbru@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 17:01:07 +0100
Markus Armbruster <armbru@redhat.com> wrote:

> g_new(T, n) is neater than g_malloc(sizeof(T) * n).  It's also safer,
> for two reasons.  One, it catches multiplication overflowing size_t.
> Two, it returns T * rather than void *, which lets the compiler catch
> more type errors.
> 
> This commit only touches allocations with size arguments of the form
> sizeof(T).
> 
> Patch created mechanically with:
> 
>     $ spatch --in-place --sp-file scripts/coccinelle/use-g_new-etc.cocci \
> 	     --macro-file scripts/cocci-macro-file.h FILES...
> 
> Except this uncovers a typing error:
> 
>     ../hw/9pfs/9p.c:855:13: warning: incompatible pointer types assigning to 'QpfEntry *' from 'QppEntry *' [-Wincompatible-pointer-types]
> 	    val = g_new0(QppEntry, 1);
> 		^ ~~~~~~~~~~~~~~~~~~~
>     1 warning generated.
> 
> Harmless, because QppEntry is larger than QpfEntry.  Fix to allocate a
> QpfEntry instead.
> 
> Cc: Greg Kurz <groug@kaod.org>
> Cc: Christian Schoenebeck <qemu_oss@crudebyte.com>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  hw/9pfs/9p-proxy.c           | 2 +-
>  hw/9pfs/9p-synth.c           | 4 ++--
>  hw/9pfs/9p.c                 | 8 ++++----
>  hw/9pfs/codir.c              | 6 +++---
>  tests/qtest/virtio-9p-test.c | 4 ++--
>  5 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/hw/9pfs/9p-proxy.c b/hw/9pfs/9p-proxy.c
> index 8b4b5cf7dc..4c5e0fc217 100644
> --- a/hw/9pfs/9p-proxy.c
> +++ b/hw/9pfs/9p-proxy.c
> @@ -1187,7 +1187,7 @@ static int proxy_parse_opts(QemuOpts *opts, FsDriverEntry *fs, Error **errp)
>  
>  static int proxy_init(FsContext *ctx, Error **errp)
>  {
> -    V9fsProxy *proxy = g_malloc(sizeof(V9fsProxy));
> +    V9fsProxy *proxy = g_new(V9fsProxy, 1);
>      int sock_id;
>  
>      if (ctx->export_flags & V9FS_PROXY_SOCK_NAME) {
> diff --git a/hw/9pfs/9p-synth.c b/hw/9pfs/9p-synth.c
> index b3080e415b..d99d263985 100644
> --- a/hw/9pfs/9p-synth.c
> +++ b/hw/9pfs/9p-synth.c
> @@ -49,7 +49,7 @@ static V9fsSynthNode *v9fs_add_dir_node(V9fsSynthNode *parent, int mode,
>  
>      /* Add directory type and remove write bits */
>      mode = ((mode & 0777) | S_IFDIR) & ~(S_IWUSR | S_IWGRP | S_IWOTH);
> -    node = g_malloc0(sizeof(V9fsSynthNode));
> +    node = g_new0(V9fsSynthNode, 1);
>      if (attr) {
>          /* We are adding .. or . entries */
>          node->attr = attr;
> @@ -128,7 +128,7 @@ int qemu_v9fs_synth_add_file(V9fsSynthNode *parent, int mode,
>      }
>      /* Add file type and remove write bits */
>      mode = ((mode & 0777) | S_IFREG);
> -    node = g_malloc0(sizeof(V9fsSynthNode));
> +    node = g_new0(V9fsSynthNode, 1);
>      node->attr         = &node->actual_attr;
>      node->attr->inode  = synth_node_count++;
>      node->attr->nlink  = 1;
> diff --git a/hw/9pfs/9p.c b/hw/9pfs/9p.c
> index a6d6b3f835..8e9d4aea73 100644
> --- a/hw/9pfs/9p.c
> +++ b/hw/9pfs/9p.c
> @@ -324,7 +324,7 @@ static V9fsFidState *alloc_fid(V9fsState *s, int32_t fid)
>              return NULL;
>          }
>      }
> -    f = g_malloc0(sizeof(V9fsFidState));
> +    f = g_new0(V9fsFidState, 1);
>      f->fid = fid;
>      f->fid_type = P9_FID_NONE;
>      f->ref = 1;
> @@ -804,7 +804,7 @@ static int qid_inode_prefix_hash_bits(V9fsPDU *pdu, dev_t dev)
>  
>      val = qht_lookup(&pdu->s->qpd_table, &lookup, hash);
>      if (!val) {
> -        val = g_malloc0(sizeof(QpdEntry));
> +        val = g_new0(QpdEntry, 1);
>          *val = lookup;
>          affix = affixForIndex(pdu->s->qp_affix_next);
>          val->prefix_bits = affix.bits;
> @@ -852,7 +852,7 @@ static int qid_path_fullmap(V9fsPDU *pdu, const struct stat *stbuf,
>              return -ENFILE;
>          }
>  
> -        val = g_malloc0(sizeof(QppEntry));
> +        val = g_new0(QpfEntry, 1);
>          *val = lookup;
>  
>          /* new unique inode and device combo */
> @@ -928,7 +928,7 @@ static int qid_path_suffixmap(V9fsPDU *pdu, const struct stat *stbuf,
>              return -ENFILE;
>          }
>  
> -        val = g_malloc0(sizeof(QppEntry));
> +        val = g_new0(QppEntry, 1);
>          *val = lookup;
>  
>          /* new unique inode affix and device combo */
> diff --git a/hw/9pfs/codir.c b/hw/9pfs/codir.c
> index 75148bc985..93ba44fb75 100644
> --- a/hw/9pfs/codir.c
> +++ b/hw/9pfs/codir.c
> @@ -141,9 +141,9 @@ static int do_readdir_many(V9fsPDU *pdu, V9fsFidState *fidp,
>  
>          /* append next node to result chain */
>          if (!e) {
> -            *entries = e = g_malloc0(sizeof(V9fsDirEnt));
> +            *entries = e = g_new0(V9fsDirEnt, 1);
>          } else {
> -            e = e->next = g_malloc0(sizeof(V9fsDirEnt));
> +            e = e->next = g_new0(V9fsDirEnt, 1);
>          }
>          e->dent = qemu_dirent_dup(dent);
>  
> @@ -163,7 +163,7 @@ static int do_readdir_many(V9fsPDU *pdu, V9fsFidState *fidp,
>                  break;
>              }
>  
> -            e->st = g_malloc0(sizeof(struct stat));
> +            e->st = g_new0(struct stat, 1);
>              memcpy(e->st, &stbuf, sizeof(struct stat));
>          }
>  
> diff --git a/tests/qtest/virtio-9p-test.c b/tests/qtest/virtio-9p-test.c
> index 01ca076afe..e28c71bd8f 100644
> --- a/tests/qtest/virtio-9p-test.c
> +++ b/tests/qtest/virtio-9p-test.c
> @@ -468,12 +468,12 @@ static void v9fs_rreaddir(P9Req *req, uint32_t *count, uint32_t *nentries,
>           togo -= 13 + 8 + 1 + 2 + slen, ++n)
>      {
>          if (!e) {
> -            e = g_malloc(sizeof(struct V9fsDirent));
> +            e = g_new(struct V9fsDirent, 1);
>              if (entries) {
>                  *entries = e;
>              }
>          } else {
> -            e = e->next = g_malloc(sizeof(struct V9fsDirent));
> +            e = e->next = g_new(struct V9fsDirent, 1);
>          }
>          e->next = NULL;
>          /* qid[13] offset[8] type[1] name[s] */

