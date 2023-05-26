Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4523A711F72
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 07:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbjEZF5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 01:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbjEZF5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 01:57:38 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D12125;
        Thu, 25 May 2023 22:57:37 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q2pUNJ020505;
        Fri, 26 May 2023 05:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=fb944hnk4OQxeG+6V2C3RbCCAeYGSq5eRoMdvRUqiso=;
 b=Sy8IZmyQIiMzoWnyeIOayl3Ouw0oyVoSLpWLHnuHSn2H6zCj+jdZKr5aLblVCAgo7Bl3
 HrANQNaIi1e1gtIySLWY8G2/lRQ90V21yRtnsF97TrQ/UgV8l7W9YGMLNfuHAc3XdfnL
 Y6FTl1rB6E11gBL+D0VEdp9XtecIVewNqVn64lRLZC0wVUHO05dOCeDIDa/9vAJb7xUP
 u+JuLHHwdhhhyiOGlcWgt08wIEzwG3CgsvpXqNDWxtDDCyUeTBZTAgv1uv68TzOzRSzj
 zSAc7iQ3gCoi8DdpF65BjQeGqiSjnwoKUivGXOJRiOtBQkjqywzxiJMKHjsXpN/izSjN SQ== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qt5uft5tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 May 2023 05:57:33 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34Q5vWgr016238
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 May 2023 05:57:32 GMT
Received: from [10.110.51.179] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Thu, 25 May
 2023 22:57:31 -0700
Message-ID: <f098c2c5-1fa3-0a74-b103-f38f5d68dd1d@quicinc.com>
Date:   Thu, 25 May 2023 22:57:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Content-Language: en-US
To:     <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230509040734.24392-1-ankita@nvidia.com>
From:   Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <20230509040734.24392-1-ankita@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: UqHGV6hDi5sMR-ZR7xlZz7rrjnN1IQF6
X-Proofpoint-GUID: UqHGV6hDi5sMR-ZR7xlZz7rrjnN1IQF6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 adultscore=0 priorityscore=1501 mlxlogscore=692 spamscore=0 bulkscore=0
 impostorscore=0 phishscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260049
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/8/2023 9:07 PM, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal propritary cache coherent interconnect.

           ^proprietary

---Trilok Soni

