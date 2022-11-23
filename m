Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1323D635F8E
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiKWN2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbiKWN2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:28:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59993BE27;
        Wed, 23 Nov 2022 05:07:43 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AND2HNq034037;
        Wed, 23 Nov 2022 13:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dpzs+D9sp2IPvqiFiyCNfqHgrhQ8nIlbGtoIbOkojJI=;
 b=efcvpbcXVvvHIyjr24qUWh+oAo7ZFJnQ7csz24PqQZ9OwX3CCa+OnVltloVgIfA+nXMd
 6Vb9Vlx0oM7kVx/3c6gRVLRImQyJtrXI40jFNE+I5OlGRdTgYMRZc4IH+g2j0kN3U777
 00IaGTpfuo/u3295cLZbdY6erN7hApXfbglh7SIK4uLYGZvQ3Xrn9BnGGknPTFe3NLDB
 ZETyQx3h2KIfDKUeF7gdJ+6j60xMkVnT1X7ygIGkXMsMVweSrRvE5G0tFTz+L7CKiRI9
 u1nEkd1FCpcsRW8v1rqRHXFNghKHxJmNtP+OZH93zDYABLFDP3ncvj0x9UsjaSp09NbU RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1da3fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:42 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANCBQdR037010;
        Wed, 23 Nov 2022 13:07:42 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1da3f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AND4pML024068;
        Wed, 23 Nov 2022 13:07:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3kxps8wrev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:40 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AND7ajL61604328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:07:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE303A405C;
        Wed, 23 Nov 2022 13:07:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D14CA4054;
        Wed, 23 Nov 2022 13:07:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:07:36 +0000 (GMT)
Date:   Wed, 23 Nov 2022 13:46:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: sie: Set guest memory
 pointer
Message-ID: <20221123134630.0f67da2d@p-imbrenda>
In-Reply-To: <20221123084656.19864-4-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
        <20221123084656.19864-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sX9e5eifb51jJqdlQOFnc4xe8TizbP9P
X-Proofpoint-ORIG-GUID: P8dkmnYYfoDnyBHdsZynxkbPARVkritU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 08:46:54 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Seems like it was introduced but never set. It's nicer to have a
> pointer than to cast the MSO of a VM.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index a71985b6..9241b4b4 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -93,6 +93,7 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
>  
>  	/* Guest memory chunks are always 1MB */
>  	assert(!(guest_mem_len & ~HPAGE_MASK));
> +	vm->guest_mem = (uint8_t *)guest_mem;
>  	/* For non-PV guests we re-use the host's ASCE for ease of use */
>  	vm->save_area.guest.asce = stctg(1);
>  	/* Currently MSO/MSL is the easiest option */

