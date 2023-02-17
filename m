Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FD069AFB2
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 16:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjBQPlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 10:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjBQPlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 10:41:21 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D906EF3D;
        Fri, 17 Feb 2023 07:41:20 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31HDJChi010262;
        Fri, 17 Feb 2023 15:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=B1s4odGrNH/WLn2DZFcs3zFbDP0JcNMLBzoCFQKqMs8=;
 b=LdFJ5CVwqjRmdyL9N+o8WS3Yx1FW9APfYXTJ+0CgImohBNCNk/OhVJ4n32gOZRnEvtmA
 So538RVqtLIvdU4dilhuUdJhD4Hw/OUlBCqkwzPlf+Uq1rM6ZhC6+4V8IeaX311RSdIW
 1J68qsfXQyGvJxoO2iOoy2qq8a4jo82tXaDdduOvEaN6uPfhwmjjNQifdt99fGDTdqpA
 TlWHRESzGmPuN31mqmR2Mnr2CfZsmiTQYXul0rjGrLPQP8elXLQuvS0nZnyCXhiPaZpd
 AtxCB7Biq33QXF9oaK+fvU7VP7rQ1D+XecbvauG/tBK8ONdnAI8hBDijayznjOMTt1bh 8A== 
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nt10u1r9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 15:41:15 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
        by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 31HFfEB1015306
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 15:41:14 GMT
Received: from [10.216.18.25] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 17 Feb
 2023 07:41:11 -0800
Message-ID: <afad5956-58d9-619a-6257-ba07f0f40fd0@quicinc.com>
Date:   Fri, 17 Feb 2023 21:11:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 4/6] tools/kvm_stat: use canonical ftrace path
Content-Language: en-US
To:     Ross Zwisler <zwisler@chromium.org>, <linux-kernel@vger.kernel.org>
CC:     Ross Zwisler <zwisler@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20230215223350.2658616-1-zwisler@google.com>
 <20230215223350.2658616-5-zwisler@google.com>
From:   Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20230215223350.2658616-5-zwisler@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: K-m9dIAP1sr3RNZlhAdw5CpPSTfKVg7R
X-Proofpoint-GUID: K-m9dIAP1sr3RNZlhAdw5CpPSTfKVg7R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_10,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxscore=0 impostorscore=0
 adultscore=0 mlxlogscore=740 phishscore=0 suspectscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170140
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/16/2023 4:03 AM, Ross Zwisler wrote:
> The canonical location for the tracefs filesystem is at /sys/kernel/tracing.
> 
> But, from Documentation/trace/ftrace.rst:
> 
>    Before 4.1, all ftrace tracing control files were within the debugfs
>    file system, which is typically located at /sys/kernel/debug/tracing.
>    For backward compatibility, when mounting the debugfs file system,
>    the tracefs file system will be automatically mounted at:
> 
>    /sys/kernel/debug/tracing
> 
> A comment in kvm_stat still refers to this older debugfs path, so let's
> update it to avoid confusion.
> 
> Signed-off-by: Ross Zwisler <zwisler@google.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index 6f28180ffeea..15bf00e79e3f 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -627,7 +627,7 @@ class TracepointProvider(Provider):
>           name)'.
>   
>           All available events have directories under
> -        /sys/kernel/debug/tracing/events/ which export information
> +        /sys/kernel/tracing/events/ which export information
>           about the specific event. Therefore, listing the dirs gives us
>           a list of all available events.
>   

Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh
