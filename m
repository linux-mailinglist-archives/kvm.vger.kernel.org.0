Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30614B3AD
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 10:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbfFSILE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 04:11:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:47182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbfFSILD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 04:11:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 657F2AF1F;
        Wed, 19 Jun 2019 08:11:01 +0000 (UTC)
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 mQINBE6KyREBEACwRN6XKClPtxPiABx5GW+Yr1snfhjzExxkTYaINHsWHlsLg13kiemsS6o7
 qrc+XP8FmhcnCOts9e2jxZxtmpB652lxRB9jZE40mcSLvYLM7S6aH0WXKn8bOqpqOGJiY2bc
 6qz6rJuqkOx3YNuUgiAxjuoYauEl8dg4bzex3KGkGRuxzRlC8APjHlwmsr+ETxOLBfUoRNuE
 b4nUtaseMPkNDwM4L9+n9cxpGbdwX0XwKFhlQMbG3rWA3YqQYWj1erKIPpgpfM64hwsdk9zZ
 QO1krgfULH4poPQFpl2+yVeEMXtsSou915jn/51rBelXeLq+cjuK5+B/JZUXPnNDoxOG3j3V
 VSZxkxLJ8RO1YamqZZbVP6jhDQ/bLcAI3EfjVbxhw9KWrh8MxTcmyJPn3QMMEp3wpVX9nSOQ
 tzG72Up/Py67VQe0x8fqmu7R4MmddSbyqgHrab/Nu+ak6g2RRn3QHXAQ7PQUq55BDtj85hd9
 W2iBiROhkZ/R+Q14cJkWhzaThN1sZ1zsfBNW0Im8OVn/J8bQUaS0a/NhpXJWv6J1ttkX3S0c
 QUratRfX4D1viAwNgoS0Joq7xIQD+CfJTax7pPn9rT////hSqJYUoMXkEz5IcO+hptCH1HF3
 qz77aA5njEBQrDRlslUBkCZ5P+QvZgJDy0C3xRGdg6ZVXEXJOQARAQABtCpIYW5uZXMgUmVp
 bmVja2UgKFN1U0UgTGFicykgPGhhcmVAc3VzZS5kZT6JAkEEEwECACsCGwMFCRLMAwAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheABQJOisquAhkBAAoJEGz4yi9OyKjPOHoQAJLeLvr6JNHx
 GPcHXaJLHQiinz2QP0/wtsT8+hE26dLzxb7hgxLafj9XlAXOG3FhGd+ySlQ5wSbbjdxNjgsq
 FIjqQ88/Lk1NfnqG5aUTPmhEF+PzkPogEV7Pm5Q17ap22VK623MPaltEba+ly6/pGOODbKBH
 ak3gqa7Gro5YCQzNU0QVtMpWyeGF7xQK76DY/atvAtuVPBJHER+RPIF7iv5J3/GFIfdrM+wS
 BubFVDOibgM7UBnpa7aohZ9RgPkzJpzECsbmbttxYaiv8+EOwark4VjvOne8dRaj50qeyJH6
 HLpBXZDJH5ZcYJPMgunghSqghgfuUsd5fHmjFr3hDb5EoqAfgiRMSDom7wLZ9TGtT6viDldv
 hfWaIOD5UhpNYxfNgH6Y102gtMmN4o2P6g3UbZK1diH13s9DA5vI2mO2krGz2c5BOBmcctE5
 iS+JWiCizOqia5Op+B/tUNye/YIXSC4oMR++Fgt30OEafB8twxydMAE3HmY+foawCpGq06yM
 vAguLzvm7f6wAPesDAO9vxRNC5y7JeN4Kytl561ciTICmBR80Pdgs/Obj2DwM6dvHquQbQrU
 Op4XtD3eGUW4qgD99DrMXqCcSXX/uay9kOG+fQBfK39jkPKZEuEV2QdpE4Pry36SUGfohSNq
 xXW+bMc6P+irTT39VWFUJMcSuQINBE6KyREBEACvEJggkGC42huFAqJcOcLqnjK83t4TVwEn
 JRisbY/VdeZIHTGtcGLqsALDzk+bEAcZapguzfp7cySzvuR6Hyq7hKEjEHAZmI/3IDc9nbdh
 EgdCiFatah0XZ/p4vp7KAelYqbv8YF/ORLylAdLh9rzLR6yHFqVaR4WL4pl4kEWwFhNSHLxe
 55G56/dxBuoj4RrFoX3ynerXfbp4dH2KArPc0NfoamqebuGNfEQmDbtnCGE5zKcR0zvmXsRp
 qU7+caufueZyLwjTU+y5p34U4PlOO2Q7/bdaPEdXfpgvSpWk1o3H36LvkPV/PGGDCLzaNn04
 BdiiiPEHwoIjCXOAcR+4+eqM4TSwVpTn6SNgbHLjAhCwCDyggK+3qEGJph+WNtNU7uFfscSP
 k4jqlxc8P+hn9IqaMWaeX9nBEaiKffR7OKjMdtFFnBRSXiW/kOKuuRdeDjL5gWJjY+IpdafP
 KhjvUFtfSwGdrDUh3SvB5knSixE3qbxbhbNxmqDVzyzMwunFANujyyVizS31DnWC6tKzANkC
 k15CyeFC6sFFu+WpRxvC6fzQTLI5CRGAB6FAxz8Hu5rpNNZHsbYs9Vfr/BJuSUfRI/12eOCL
 IvxRPpmMOlcI4WDW3EDkzqNAXn5Onx/b0rFGFpM4GmSPriEJdBb4M4pSD6fN6Y/Jrng/Bdwk
 SQARAQABiQIlBBgBAgAPBQJOiskRAhsMBQkSzAMAAAoJEGz4yi9OyKjPgEwQAIP/gy/Xqc1q
 OpzfFScswk3CEoZWSqHxn/fZasa4IzkwhTUmukuIvRew+BzwvrTxhHcz9qQ8hX7iDPTZBcUt
 ovWPxz+3XfbGqE+q0JunlIsP4N+K/I10nyoGdoFpMFMfDnAiMUiUatHRf9Wsif/nT6oRiPNJ
 T0EbbeSyIYe+ZOMFfZBVGPqBCbe8YMI+JiZeez8L9JtegxQ6O3EMQ//1eoPJ5mv5lWXLFQfx
 f4rAcKseM8DE6xs1+1AIsSIG6H+EE3tVm+GdCkBaVAZo2VMVapx9k8RMSlW7vlGEQsHtI0FT
 c1XNOCGjaP4ITYUiOpfkh+N0nUZVRTxWnJqVPGZ2Nt7xCk7eoJWTSMWmodFlsKSgfblXVfdM
 9qoNScM3u0b9iYYuw/ijZ7VtYXFuQdh0XMM/V6zFrLnnhNmg0pnK6hO1LUgZlrxHwLZk5X8F
 uD/0MCbPmsYUMHPuJd5dSLUFTlejVXIbKTSAMd0tDSP5Ms8Ds84z5eHreiy1ijatqRFWFJRp
 ZtWlhGRERnDH17PUXDglsOA08HCls0PHx8itYsjYCAyETlxlLApXWdVl9YVwbQpQ+i693t/Y
 PGu8jotn0++P19d3JwXW8t6TVvBIQ1dRZHx1IxGLMn+CkDJMOmHAUMWTAXX2rf5tUjas8/v2
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <760164a0-589d-d9fa-fb63-79b5e0899c00@suse.de>
Date:   Wed, 19 Jun 2019 10:11:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/19 1:28 PM, Paolo Bonzini wrote:
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
> 
> The use case for this is plugged IO, where blk-mq flushes a batch of
> requests all at once.
> 
> The API is the same as for blk-mq, just with blk-mq concepts tweaked to
> fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
> a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
> extracted from the hctx and passed as a parameter.
> 
> The only complication is that blk-mq uses different plugging heuristics
> depending on whether commit_rqs is present or not.  So we have two
> different sets of blk_mq_ops and pick one depending on whether the
> scsi_host template uses commit_rqs or not.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c  | 37 ++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_cmnd.h |  1 +
>  include/scsi/scsi_host.h | 16 ++++++++++++++--
>  3 files changed, 49 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 601b9f1de267..eb4e67d02bfe 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1673,10 +1673,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		blk_mq_start_request(req);
>  	}
>  
> +	cmd->flags &= SCMD_PRESERVED_FLAGS;
>  	if (sdev->simple_tags)
>  		cmd->flags |= SCMD_TAGGED;
> -	else
> -		cmd->flags &= ~SCMD_TAGGED;
> +	if (bd->last)
> +		cmd->flags |= SCMD_LAST;
>  
>  	scsi_init_cmd_errh(cmd);
>  	cmd->scsi_done = scsi_mq_done;
> @@ -1807,10 +1808,37 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(__scsi_init_queue);
>  
> +static const struct blk_mq_ops scsi_mq_ops_no_commit = {
> +	.get_budget	= scsi_mq_get_budget,
> +	.put_budget	= scsi_mq_put_budget,
> +	.queue_rq	= scsi_queue_rq,
> +	.complete	= scsi_softirq_done,
> +	.timeout	= scsi_timeout,
> +#ifdef CONFIG_BLK_DEBUG_FS
> +	.show_rq	= scsi_show_rq,
> +#endif
> +	.init_request	= scsi_mq_init_request,
> +	.exit_request	= scsi_mq_exit_request,
> +	.initialize_rq_fn = scsi_initialize_rq,
> +	.busy		= scsi_mq_lld_busy,
> +	.map_queues	= scsi_map_queues,
> +};
> +
> +
> +static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
> +{
> +	struct request_queue *q = hctx->queue;
> +	struct scsi_device *sdev = q->queuedata;
> +	struct Scsi_Host *shost = sdev->host;
> +
> +	shost->hostt->commit_rqs(shost, hctx->queue_num);
> +}
> +
>  static const struct blk_mq_ops scsi_mq_ops = {
>  	.get_budget	= scsi_mq_get_budget,
>  	.put_budget	= scsi_mq_put_budget,
>  	.queue_rq	= scsi_queue_rq,
> +	.commit_rqs	= scsi_commit_rqs,
>  	.complete	= scsi_softirq_done,
>  	.timeout	= scsi_timeout,
>  #ifdef CONFIG_BLK_DEBUG_FS
> @@ -1845,7 +1873,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>  		cmd_size += sizeof(struct scsi_data_buffer) + sgl_size;
>  
>  	memset(&shost->tag_set, 0, sizeof(shost->tag_set));
> -	shost->tag_set.ops = &scsi_mq_ops;
> +	if (shost->hostt->commit_rqs)
> +		shost->tag_set.ops = &scsi_mq_ops;
> +	else
> +		shost->tag_set.ops = &scsi_mq_ops_no_commit;
>  	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>  	shost->tag_set.queue_depth = shost->can_queue;
>  	shost->tag_set.cmd_size = cmd_size;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 76ed5e4acd38..91bd749a02f7 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -57,6 +57,7 @@ struct scsi_pointer {
>  #define SCMD_TAGGED		(1 << 0)
>  #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
>  #define SCMD_INITIALIZED	(1 << 2)
> +#define SCMD_LAST		(1 << 3)
>  /* flags preserved across unprep / reprep */
>  #define SCMD_PRESERVED_FLAGS	(SCMD_UNCHECKED_ISA_DMA | SCMD_INITIALIZED)
>  
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 2b539a1b3f62..28f1c9177cd2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -80,8 +80,10 @@ struct scsi_host_template {
>  	 * command block to the LLDD.  When the driver finished
>  	 * processing the command the done callback is invoked.
>  	 *
> -	 * If queuecommand returns 0, then the HBA has accepted the
> -	 * command.  The done() function must be called on the command
> +	 * If queuecommand returns 0, then the driver has accepted the
> +	 * command.  It must also push it to the HBA if the scsi_cmnd
> +	 * flag SCMD_LAST is set, or if the driver does not implement
> +	 * commit_rqs.  The done() function must be called on the command
>  	 * when the driver has finished with it. (you may call done on the
>  	 * command before queuecommand returns, but in this case you
>  	 * *must* return 0 from queuecommand).
> @@ -109,6 +111,16 @@ struct scsi_host_template {
>  	 */
>  	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
>  
> +	/*
> +	 * The commit_rqs function is used to trigger a hardware
> +	 * doorbell after some requests have been queued with
> +	 * queuecommand, when an error is encountered before sending
> +	 * the request with SCMD_LAST set.
> +	 *
> +	 * STATUS: OPTIONAL
> +	 */
> +	void (*commit_rqs)(struct Scsi_Host *, u16);
> +
>  	/*
>  	 * This is an error handling strategy routine.  You don't need to
>  	 * define one of these if you don't want to - there is a default
> 
I'm a bit unsure if 'bd->last' is always set; it's quite obvious that
it's present if set, but what about requests with 'bd->last == false' ?
Is there a guarantee that they will _always_ be followed with a request
with bd->last == true?
And if so, is there a guarantee that this request is part of the same batch?

Aside from it: I think it's a good idea to match the '->last' setting
onto the SCMD_LAST flag; I would even go so far and make this an
independent patch.

Once to above points are cleared, that is.

But if that one is in, why do we need to have the separate 'commit_rqs'
callback?
Can't we let the driver decide to issue a doorbell kick (or whatever the
driver decides to do there)?
If we ensure that the SCMD_LAST flag is always set for the end of a
batch (even if this batch consists only of one request), the driver
simply can evaluate the flag and do its actions.
Why do we need a new callback here?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
