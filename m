Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5986233A59
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgG3VKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 17:10:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbgG3VKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 17:10:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UL1kii144978
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : from : subject :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cobRzjEpBLwZku9+RNbw0pbhm/V1p8fvAj5wkVWUu84=;
 b=wuAFacQLZGv1Mn3HQwhS8cpEtjpo6VCs2clpTeQONB6U3flnMcpre7xRaRlLjm1TJhc7
 eLRahjdpGyggnJNcWwh8BH96ILL95iXRtiaNT2OLsAMTcpN3wbE8qUerYzj9A5ZORJYd
 a5hXkkJ0daCbdIU1TUvBsyjVbyv66G9GTBgiAfvXLJFSgLCZGo7rVggk29U8PiYlkfhe
 T2kC2LPpuRvGvkonG4fHB+n0z+GIkng8hDHCc0Ru0X2RMUjhlj8+5kAXH8/ftA3yBIQm
 L1lvaRWkXriMDdVwAUnrIipbsBAHF+0bF3Za+fc66tbNsjY5QLH6JNeim/ztyPtPAp2r Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1jx0fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:10:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06UL2pQo055278
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:10:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32hu5xxp58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:10:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06ULAhGC016907
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 21:10:43 GMT
Received: from localhost.localdomain (/10.159.234.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jul 2020 14:10:43 -0700
To:     kvm <kvm@vger.kernel.org>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Guest identity in VMCS/VMCB
Message-ID: <8f77270a-b47e-8e69-2e36-f28de927cd7a@oracle.com>
Date:   Thu, 30 Jul 2020 14:10:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=825
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=848
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007300148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I am debugging and looking at the trace-point output for a guest, there is no way for me to determine whether a given trace-point, say, {vmx|svm}_handle_exit() or {vmx|svm}_vcpu_run(), was executed as part of which L1/L2 guest. As VMs do such operations so many times in a short period of time, trace-point output looks overwhelming and is of no use when  analyzed from this angle.

Does it makes sense to embed some sort of guest identification within the VMCS/VMCB, say, loaded_vmcs or vmcb, so that trace-points can spit out which guest/nested-guest executed the operation ?


-Krish

