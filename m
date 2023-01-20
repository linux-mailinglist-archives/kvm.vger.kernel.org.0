Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B6F6757EB
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjATPAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjATPAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:00:09 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE2641B72;
        Fri, 20 Jan 2023 07:00:07 -0800 (PST)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KEx1X8000559;
        Fri, 20 Jan 2023 14:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=3HrTy6KRH0c8nn8RZz4UfVbeho7HoRu2+7rX1+TKX6o=;
 b=NrU0ke3Gq12txpQ4inx0oalb6FODLnpl/63NNfyMI4fRK915a1sfFJm+ZGTnSS6XUrmu
 6JDQbXXMyz+2t8MbTxD29cp9Xpd5/s2d9L7019nVyU9S0p6FtIO7AXRxqP4O+Em0crSd
 TRf3FojLW1/lbKiJeWDql6YEtTvYMF7NuF1wFVFgVcjgtQdR9uXTE32YwyPGz6DGz0eG
 2VX9BXcRazJ0GM4DZHR4jJ1+58AiC4pLsm+wo+SNYERuIBSLfmp2ZDR4NQdZENhSDlHA
 8HgUC93d+ZbYBetZ7ze5TMKhAmDbckmxTTKJqbn6+ZPeA9+uTO0p7cuJZFybsIlviJzj 8w== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3n7c28hwv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:59:42 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 30KExfev006092
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:59:41 GMT
Received: from [10.226.59.182] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 06:59:40 -0800
Message-ID: <8a5c3cc6-c1e5-b6c4-e69d-441cf3a1fa7d@quicinc.com>
Date:   Fri, 20 Jan 2023 07:59:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH linux-next 1/3] Documentation: accel: escape wildcard in
 special file path
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Freedesktop DRI List <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
CC:     Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ofir Bitton <obitton@habana.ai>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20230120123534.137413-1-bagasdotme@gmail.com>
 <20230120123534.137413-2-bagasdotme@gmail.com>
From:   Jeffrey Hugo <quic_jhugo@quicinc.com>
In-Reply-To: <20230120123534.137413-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: c49osEI-LfEgRsTJD9aA3ZchrnIv8A_-
X-Proofpoint-ORIG-GUID: c49osEI-LfEgRsTJD9aA3ZchrnIv8A_-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_09,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=954
 clxscore=1011 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200142
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/2023 5:35 AM, Bagas Sanjaya wrote:
> Stephen Rothwell reported htmldocs warning then merging accel tree:
> 
> Documentation/accel/introduction.rst:72: WARNING: Inline emphasis start-string without end-string.
> 
> Sphinx confuses the file wildcards with inline emphasis (italics), hence
> the warning.
> 
> Fix the warning by escaping wildcards.
> 
> Link: https://lore.kernel.org/linux-next/20230120132116.21de1104@canb.auug.org.au/
> Fixes: f65c5dac207322 ("docs: accel: Fix debugfs path")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Thanks for addressing this before I even saw the warning report.

Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
