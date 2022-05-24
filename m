Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40F2532D24
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiEXPQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiEXPQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:16:11 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFB2266F;
        Tue, 24 May 2022 08:16:09 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OEoQF2005043;
        Tue, 24 May 2022 15:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=h+oSk7wdyj2LSQQADXzylMWo1+x33ptItdn7rNSWQ8I=;
 b=prsCJho/MKSsjRykXQ77TIQYdxsQZ8NjXebAQwF9HlmC0o4e1FK5W1m6HCLMqxOg6X4u
 3gJPa9RyjlLDidEVN5crp9ze4Y2qj6VuEyZmbSN53vdLxTQyqw8VOLu6JR/x5+ooK6NF
 xI1iwFPFfYNFpRd0kMpXtYy1X8YzO5e/e4Vp/e5WpzNViB3xajWDE67ozdHDBrL2lmyB
 XeHBaAsBWtCvQvGSqYqI/yGBNarZHw7E9UxkspiTLzMeAvC1XXaij4ICm5wUjs3PudJR
 Y42lUvBdJZsKEhGb5nBXywaDHwyWU0iuaf1hgZsqn05wUa8MFML/7HTHKU+GO3YLfFgw oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g91fv0nnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 15:16:08 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OEp9iU006481;
        Tue, 24 May 2022 15:16:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g91fv0nmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 15:16:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OFDE5G009046;
        Tue, 24 May 2022 15:16:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3g6qq8w3gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 15:16:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OFG35d13697352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 15:16:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5001EA405F;
        Tue, 24 May 2022 15:16:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2490A4054;
        Tue, 24 May 2022 15:16:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.98])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 15:16:02 +0000 (GMT)
Date:   Tue, 24 May 2022 17:01:33 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: Test effect of storage
 keys on diag 308
Message-ID: <20220524170133.64edfada@p-imbrenda>
In-Reply-To: <20220523132406.1820550-4-scgl@linux.ibm.com>
References: <20220523132406.1820550-1-scgl@linux.ibm.com>
        <20220523132406.1820550-4-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KvdCGsnW2resNhwXq2lcHqTk99LsHh2O
X-Proofpoint-GUID: 6TUxuMIOsLPN--nQLUn8sRStQT1V4E-H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_07,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 May 2022 15:24:06 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Test that key-controlled protection does not apply to diag 308.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/skey.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index a55034b5..074667e2 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -300,6 +300,31 @@ static void test_store_cpu_address(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_diag_308(void)
> +{
> +	uint16_t response;
> +	uint32_t *ipib = (uint32_t *)pagebuf;
> +
> +	report_prefix_push("DIAG 308");
> +	WRITE_ONCE(ipib[0], 0); /* Invalid length */
> +	set_storage_key(ipib, 0x28, 0);
> +	/* key-controlled protection does not apply */
> +	asm volatile (
> +		"lr	%%r2,%[ipib]\n\t"
> +		"spka	0x10\n\t"
> +		"diag	%%r2,%[code],0x308\n\t"
> +		"spka	0\n\t"
> +		"lr	%[response],%%r3\n"
> +		: [response] "=d" (response)
> +		: [ipib] "d" (ipib),
> +		  [code] "d" (5)
> +		: "%r2", "%r3"
> +	);
> +	report(response == 0x402, "no exception on fetch, response: invalid IPIB");
> +	set_storage_key(ipib, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
>  /*
>   * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
>   * with access key 1.
> @@ -712,6 +737,7 @@ int main(void)
>  	test_chg();
>  	test_test_protection();
>  	test_store_cpu_address();
> +	test_diag_308();
>  	test_channel_subsystem_call();
>  
>  	setup_vm();

