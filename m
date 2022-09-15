Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D911A5B9690
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiIOIqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 04:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiIOIqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 04:46:13 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC597ED2;
        Thu, 15 Sep 2022 01:46:12 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F5mvG5013826;
        Thu, 15 Sep 2022 08:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=n7MG+DVVpKBkqQl59cxQlyiMIMlHdrLNPnjubEpTa+E=;
 b=A9x/F7qnIaMikDRtpjww8Bu0nT+vEr8c3VIKnyhQ50xogN1AdxxANsZPERqFi+dzbcv/
 vzZKTF04frAKd7yR/Z6hJd+cjegw2nvNnsEvAM/DdHGHmBizJlB0juYiVpFONvauIEka
 7RY1gY5W53/ppi7kndu7jNFHAUU/53AXQPzLjNEF0JpuisWo1HtEQmsvxAVcdB23MpdI
 r1A4dlfky1A6TYxj0VPAR3TyvqJ7lk5/7ZChUD5lW6UfFNxJ8Dq3GiyIu2ummz7ZSrht
 8DKphet8T8pWZVxvKDC4jm01YhGsnPAbNq7xmV6+7CG50Vb8FMyj5FYOdCB7jSp5vNlq Jw== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jkqm1hm4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 08:45:59 +0000
Received: from pps.filterd (NASANPPMTA03.qualcomm.com [127.0.0.1])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28F8Tu8Y018524;
        Thu, 15 Sep 2022 08:40:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA03.qualcomm.com (PPS) with ESMTPS id 3jkb9b0dhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 08:40:58 +0000
Received: from NASANPPMTA03.qualcomm.com (NASANPPMTA03.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28F8ewFa004512;
        Thu, 15 Sep 2022 08:40:58 GMT
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
        by NASANPPMTA03.qualcomm.com (PPS) with ESMTPS id 28F8ewdE004508
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 08:40:58 +0000
Received: from [10.216.25.163] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 15 Sep
 2022 01:40:53 -0700
Message-ID: <92770899-d56b-8bcd-f613-32d7b7ddd30b@quicinc.com>
Date:   Thu, 15 Sep 2022 14:10:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH -next] rcu: remove unused 'cpu' in
 rcu_virt_note_context_switch
Content-Language: en-US
To:     Zeng Heng <zengheng4@huawei.com>, <pbonzini@redhat.com>,
        <paulmck@kernel.org>, <frederic@kernel.org>,
        <quic_neeraju@quicinc.com>, <josh@joshtriplett.org>,
        <rostedt@goodmis.org>, <mathieu.desnoyers@efficios.com>,
        <jiangshanlai@gmail.com>, <joel@joelfernandes.org>
CC:     <kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <liwei391@huawei.com>
References: <20220915083824.766645-1-zengheng4@huawei.com>
From:   Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20220915083824.766645-1-zengheng4@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: cDjpdiCTdnyqr5l7asjedC7hzZ29TDfe
X-Proofpoint-GUID: cDjpdiCTdnyqr5l7asjedC7hzZ29TDfe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_04,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150047
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/15/2022 2:08 PM, Zeng Heng wrote:
> Remove unused function argument, and there is
> no logic changes.
> 
> Signed-off-by: Zeng Heng <zengheng4@huawei.com>
> ---
>   include/linux/kvm_host.h | 2 +-
>   include/linux/rcutiny.h  | 2 +-
>   include/linux/rcutree.h  | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f4519d3689e1..9cf0c503daf5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -417,7 +417,7 @@ static __always_inline void guest_context_enter_irqoff(void)
>   	 */
>   	if (!context_tracking_guest_enter()) {
>   		instrumentation_begin();
> -		rcu_virt_note_context_switch(smp_processor_id());
> +		rcu_virt_note_context_switch();
>   		instrumentation_end();
>   	}
>   }
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index 768196a5f39d..9bc025aa79a3 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -142,7 +142,7 @@ static inline int rcu_needs_cpu(void)
>    * Take advantage of the fact that there is only one CPU, which
>    * allows us to ignore virtualization-based context switches.
>    */
> -static inline void rcu_virt_note_context_switch(int cpu) { }
> +static inline void rcu_virt_note_context_switch(void) { }
>   static inline void rcu_cpu_stall_reset(void) { }
>   static inline int rcu_jiffies_till_stall_check(void) { return 21 * HZ; }
>   static inline void rcu_irq_exit_check_preempt(void) { }
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 5efb51486e8a..70795386b9ff 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -27,7 +27,7 @@ void rcu_cpu_stall_reset(void);
>    * wrapper around rcu_note_context_switch(), which allows TINY_RCU
>    * to save a few bytes. The caller must have disabled interrupts.
>    */
> -static inline void rcu_virt_note_context_switch(int cpu)
> +static inline void rcu_virt_note_context_switch(void)
>   {
>   	rcu_note_context_switch(false);
>   }

Good catch.

Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh

