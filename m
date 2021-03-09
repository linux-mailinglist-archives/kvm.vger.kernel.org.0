Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0F331B9A
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 01:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhCIAVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 19:21:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231928AbhCIAVO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 19:21:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12902YG0158925;
        Mon, 8 Mar 2021 19:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bYkZf8inncM42ojubFY1EA73hItazVPFDfrnTI1cWuM=;
 b=jD9h6mxV1E2r3Br8iggZx8RJqeFrAs2Ymy2G7zwLp69gF4s7h8xYDzaKDH9HIdmQzTA4
 qCl4Dq98SauytRLoKT2q6w2oYFlB6sAN5ZIwm9kWDW4TRwIpw1/39KFS/v6k8NKdaQ7h
 8tkiUrlBVLjoQdV+syrzAmP1Qzo+CxPrjGK29ppxaIuRLK1n+GDiB5zPeCsK1J+rieve
 m0A6X1bJ/FjFnCw4Zv8EmwwGACOm6XyUDwDb1gnSo6/aUVFotpuY8GzW6rZIJMReTa5g
 LXRzNbnYbGl1ShESWnukbREMNZzvF9pF8an1Qs5rZ/XSn6grJ7KyBpzoLxW1n9jkV/uw Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375wdth9u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 19:21:13 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12902pHQ159823;
        Mon, 8 Mar 2021 19:21:13 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375wdth9tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 19:21:13 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 12908HeW003282;
        Tue, 9 Mar 2021 00:21:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3741c8a8pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 00:21:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1290KrsB13173210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 00:20:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A04B64C044;
        Tue,  9 Mar 2021 00:21:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 278134C040;
        Tue,  9 Mar 2021 00:21:08 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.56.228])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  9 Mar 2021 00:21:08 +0000 (GMT)
Date:   Tue, 9 Mar 2021 01:21:05 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH v1 13/14] vfio: Remove extern from declarations across
 vfio
Message-ID: <20210309012105.6a0d6fb6.pasic@linux.ibm.com>
In-Reply-To: <161524018283.3480.13909145183028051928.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
        <161524018283.3480.13909145183028051928.stgit@gimli.home>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_22:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 08 Mar 2021 14:49:42 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Cleanup disrecommended usage and docs.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Acked-by: Halil Pasic <pasic@linux.ibm.com>
