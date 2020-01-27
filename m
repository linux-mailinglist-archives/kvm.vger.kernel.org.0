Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BBD149EEF
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 07:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgA0GJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 01:09:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgA0GJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 01:09:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00R692KE153199;
        Mon, 27 Jan 2020 06:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0CFyygcS8p1DpncFkUetSCvI+IcRI85FcIMXzQ+Fcp4=;
 b=XhnsfEAzcKCUHgVhh1teLPiUD7ayd2Ua9sLtixUhWNaTrAdeSaYXtSJBUXNnbLQiXdml
 05LJAgDZBfXzeTrIXB/Af2Um37TztyDEklMcKnH/XBUIRlDRcO7j1cZJWjp0X0MKOBfD
 jgCRdS5nUVVcrrX9wbp93xSg7LsGBmnSF10szBdkEtbn6NJlZd0KRkiBno+OxPCarRiP
 nOI+s/iqIVj+4FokNYD/ZBc6HIAmz0S2S38wr0Rt6uAKOOqppudvPeFj/MLh1eCnt5lu
 Ua1Cxeif9to6mbvWC4A7D7G4sFLZlFZkBXgxd5Bwy45mYE0vHsUb5DLLbHwKfDXp6+jP Gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xrd3twa1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 06:09:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00R68xv4100535;
        Mon, 27 Jan 2020 06:09:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xry6qpsc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 06:08:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00R68c94029595;
        Mon, 27 Jan 2020 06:08:38 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 22:08:38 -0800
Date:   Mon, 27 Jan 2020 09:08:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
Message-ID: <20200127060832.GJ1870@kadam>
References: <20200127060305.jlq5uv6tu67tsbv4@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127060305.jlq5uv6tu67tsbv4@kili.mountain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=704
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001270053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=764 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001270053
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

See also:

arch/x86/kvm/svm.c:4289 svm_set_msr() warn: maybe use && instead of &

regards,
dan carpenter


